import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'e_onboard_profile_state.dart';
part 'onboard_profile_cubit.freezed.dart';
part 'onboard_profile_state.dart';

class OnboardProfileCubit extends Cubit<OnboardProfileState>
    with OnboardProfileCubitMixin {
  final ProfileModel profile;
  final ProfileRepo profileRepo;
  OnboardProfileCubit(this.profile, this.profileRepo)
      : super(OnboardProfileState.initial(profile)) {
    name = TextEditingController(text: profile.name ?? "");
    username = TextEditingController(text: profile.username);
    website = TextEditingController();
    bio = TextEditingController();
  }

  void updateImage({Option<File>? image, Option<File>? banner}) {
    if (image != null) {
      this.image = image;
    } else if (banner != null) {
      this.banner = banner;
    }
    emit(OnboardProfileState.response(EOnboardProfileState.ImageAdded,
        Utility.encodeStateMessage("Image Added")));
  }

  Future submit(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      Utility.cprint("Please enter required information",
          label: "Submit Profile", error: "Validation Error");
      return;
    }
    final profileURL = await image.fold(
      () => null,
      (file) async {
        return uploadProfileImage(context, file, context.locale.avatar);
      },
    );

    final bannerURL = await banner.fold(
      () => null,
      (file) async {
        return uploadProfileImage(context, file, context.locale.banner);
      },
    );
    final model = profile.copyWith.call(
        name: name.text,
        username: username.text,
        bio: bio.text,
        photoURL: profileURL ?? profile.photoURL,
        website: website.text,
        bannerURL: bannerURL);

    /// Display loader
    loader.showLoader(context, message: context.locale.updating_profile);
    final response = await profileRepo.updateUserProfile(model);

    /// Hide loader
    loader.hideLoader();

    /// Check profile update response
    response.fold((l) {
      /// An error occured while saving profile data to database
      OnboardProfileState.response(
          EOnboardProfileState.Error, Utility.encodeStateMessage(l));
      Utility.cprint(l);
    }, (r) async {
      /// Upload profile picture to firebase

      /// Profile is saved to database
      emit(OnboardProfileState.response(
          EOnboardProfileState.Updated,
          Utility.encodeStateMessage(
              context.locale.profile_updated_successfully)));
    });
  }

  /// Upload profile picture to firebase storage
  Future<String?> uploadProfileImage(
      BuildContext context, File file, String path) async {
    /// Display loader
    loader.showLoader(context, message: "uploading $path");
    final response = await profileRepo.uploadFile(
        file, "user/${profile.id}/profile/$path",
        onFileUpload: (response) => onFileUpload(context, response));

    /// Hide loader
    loader.hideLoader();
    return response.fold((l) {
      Utility.cprint(Utility.encodeStateMessage(l));
      return null;
    }, (r) {
      Utility.cprint(Utility.encodeStateMessage("Image uploaded Succesfully"));
      return r;
    });
  }

  void onFileUpload(BuildContext context, FileUploadTaskResponse response) {
    response.when(
      snapshot: (snapshot) {
        Utility.cprint('Task state: ${snapshot.state}');
        Utility.cprint(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      },
      onError: (error) {
        //
      },
    );
  }

  @override
  Future<void> close() {
    dispose();
    return super.close();
  }
}

mixin OnboardProfileCubitMixin {
  Option<File> image = none();
  Option<File> banner = none();
  late TextEditingController name;
  late TextEditingController username;
  late TextEditingController website;
  late TextEditingController bio;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void dispose() {
    name.dispose();
    username.dispose();
    website.dispose();
    bio.dispose();
  }
}
