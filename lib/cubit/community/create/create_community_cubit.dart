import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/constant.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';

part 'create_community_state.dart';
part 'e_create_community_state.dart';
part 'create_community_cubit.freezed.dart';

class CreateCommunityCubit extends Cubit<CreateCommunityState> {
  final CommunityFeedRepo communRepo;
  CreateCommunityCubit(this.communRepo)
      : super(const CreateCommunityState.response(
            ECreateCommunityState.initial)) {
    description = TextEditingController();
    name = TextEditingController();
  }

  Option<File> image = none();
  TextEditingController name;
  TextEditingController description;
  TextEditingController bio;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void updateImage({Option<File> file}) {
    image = file;
    updateState(ECreateCommunityState.loaded,
        message: Utility.encodeStateMessage("File Added"));
  }

  Future createCommunity(BuildContext context) async {
    final bool isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    var model = CommunityModel(
        name: name.text,
        description: description.text,
        createdBy: getIt<Session>().user.id,
        coverImage: CoverImage(createdAt: DateTime.now().toIso8601String()));
    DocumentReference doc;
    loader.showLoader(context, message: "Creating");
    final response = await communRepo.createCommunity(model);
    loader.hideLoader();
    response.fold(
      (l) => null,
      (r) async {
        doc = r;
        image.fold(() {
          image = none();
          updateState(ECreateCommunityState.saved,
              community: model,
              message: Utility.encodeStateMessage("Community Created"));
        }, (a) async {
          doc = r;
          final imagePath = await _uploadImages(context, doc.id);
          if (imagePath != null) {
            model = model.copyWith.call(
                avatar: imagePath,
                id: doc.id,
                coverImage: CoverImage(
                  createdAt: DateTime.now().toIso8601String(),
                  path: imagePath,
                ));
            final response = await communRepo.updateCommunity(model);
            response.fold(
              (l) {
                Utility.cprint("Image upload failure");
              },
              (r) async {
                image = none();
                updateState(ECreateCommunityState.saved,
                    community: model,
                    message: Utility.encodeStateMessage("File Added"));
              },
            );
          } else {
            Utility.cprint(
                "Some error occured while uploading community profile imkage");
          }
        });
      },
    );
  }

  /// upload files to firebase storage and get downloadable files path
  Future<String> _uploadImages(BuildContext context, String communityId) async {
    final file = image.getOrElse(() => null);
    return image.fold(
      () => null,
      (a) async {
        loader.showLoader(context, message: "Saving profile");

        /// Upload files to firebase 1 by 1
        final response = await communRepo.uploadFile(
            file,
            Constants.createFilePath(file.path,
                folderName: "${Constants.community}/$communityId/avatar"),
            onFileUpload: onFileUpload);
        loader.hideLoader();
        return response.fold(
          (l) => null,
          (r) => r,
        );
      },
    );
  }

  /// print file upload progress on console
  void onFileUpload(FileUploadTaskResponse response) {
    response.when(
      snapshot: (snapshot) {
        Utility.cprint('Task state: ${snapshot.state}');
        final value = (snapshot.bytesTransferred ~/ snapshot.totalBytes) * 100;
        Utility.cprint('Progress: $value %');
      },
      onError: (error) {
        Utility.cprint("File upload Error", error: error);
      },
    );
  }

  void updateState(ECreateCommunityState estate,
      {String message, CommunityModel community}) {
    emit(
      CreateCommunityState.response(
        estate,
        message: message,
        community: community ?? state.community,
      ),
    );
  }
}
