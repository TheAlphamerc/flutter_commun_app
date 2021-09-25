import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/constant.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/community/cover_image_model.dart';
import 'package:flutter_commun_app/model/community/social_link_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_community_cubit.freezed.dart';
part 'create_community_state.dart';
part 'e_create_community_state.dart';

class CreateCommunityCubit extends Cubit<CreateCommunityState>
    with CreateCommunityMixin, SelectCommunityTopicMxin, SocialLinksTopicMxin {
  final CommunityFeedRepo communRepo;
  CreateCommunityCubit(this.communRepo)
      : super(const CreateCommunityState.response(
            ECreateCommunityState.initial)) {
    description = TextEditingController();
    name = TextEditingController();
    topicControllers = [TextEditingController()];
    socialLinksControllers = [
      CommunityLinks(
          type: ESocialLinkType.other, controller: TextEditingController())
    ];
  }

  void updateImage({required Option<File> file, bool isBanner = false}) {
    if (isBanner) {
      banner = file;
    } else {
      image = file;
    }
    updateState(ECreateCommunityState.loaded,
        message: Utility.encodeStateMessage("File Added"));
  }

  void addTopic() {
    topicControllers.add(TextEditingController());
    updateState(ECreateCommunityState.addTopic, message: "Topic Added");
  }

  void removeTopic(int index) {
    topicControllers.removeAt(index);
    updateState(ECreateCommunityState.addTopic, message: "Topic Removed");
  }

  void addLinkTopic(ESocialLinkType type) {
    socialLinksControllers
        .add(CommunityLinks(type: type, controller: TextEditingController()));
    updateState(ECreateCommunityState.addTopic, message: "Link Added");
  }

  void removeLink(int index) {
    socialLinksControllers.removeAt(index);
    updateState(ECreateCommunityState.addTopic, message: "Link Removed");
  }

  Future createCommunity(BuildContext context) async {
    final bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    List<String>? topics;
    List<SocialLinkModel>? links;
    if (topicControllers.isNotEmpty) {
      topicControllers.removeWhere((element) => element.text.isEmpty);
      topics = [];
      for (final key in topicControllers) {
        topics.add(key.text);
      }
    }

    if (socialLinksControllers.isNotEmpty) {
      socialLinksControllers
          .removeWhere((element) => element.controller.text.isEmpty);
      links = [];
      for (final link in socialLinksControllers) {
        links.add(SocialLinkModel(
          name: link.type.encode(),
          url: link.controller.text,
          type: link.type.encode(),
        ));
      }
    }

    var model = CommunityModel(
      name: name.text,
      description: description.text,
      createdBy: getIt<Session>().user!.id,
      socialLinks: links,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      topics: topics,
    );
    DocumentReference doc;
    loader.showLoader(context, message: "Creating");
    final response = await communRepo.createCommunity(model);
    loader.hideLoader();
    response.fold(
      (l) => null,
      (r) async {
        doc = r;
        doc = r;

        final avatarImage =
            await _uploadImages(context, image, doc.id, path: "avatar");
        final bannerImage =
            await _uploadImages(context, banner, doc.id, path: "banner");
        if (avatarImage.isNotNullEmpty || bannerImage.isNotNullEmpty) {
          model = model.copyWith.call(
              avatar: avatarImage,
              banner: bannerImage,
              id: doc.id,
              coverImage: [
                CoverImage(
                  createdAt: DateTime.now().toIso8601String(),
                  path: avatarImage,
                )
              ]);
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
          image = none();
          updateState(ECreateCommunityState.saved,
              community: model,
              message: Utility.encodeStateMessage("Community Created"));
        }
      },
    );
  }

  /// upload files to firebase storage and get downloadable files path
  Future<String?> _uploadImages(
      BuildContext context, Option<File?> image, String communityId,
      {required String path}) async {
    // final file = image.valueOrDefault;
    return image.fold(
      () => null,
      (file) async {
        loader.showLoader(context, message: "Saving $path");

        /// Upload files to firebase 1 by 1
        final response = await communRepo.uploadFile(
            file!,
            Constants.createFilePath(file.path,
                folderName: "${Constants.community}/$communityId/$path"),
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
      {String? message, CommunityModel? community}) {
    emit(
      CreateCommunityState.response(
        estate,
        message: Utility.encodeStateMessage(message ?? ""),
        community: community ?? state.community,
      ),
    );
  }

  @override
  Future<void> close() {
    description.dispose();
    name.dispose();
    for (final controller in topicControllers) {
      controller.dispose();
    }
    for (final controller in socialLinksControllers) {
      controller.dispose();
    }
    return super.close();
  }
}

mixin CreateCommunityMixin {
  Option<File> image = none();
  Option<File> banner = none();
  late TextEditingController name;
  late TextEditingController description;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
}

mixin SelectCommunityTopicMxin {
  late List<TextEditingController> topicControllers;
  GlobalKey<FormState> topicsFormKey = GlobalKey<FormState>();
}

mixin SocialLinksTopicMxin {
  late List<CommunityLinks> socialLinksControllers;
  GlobalKey<FormState> linksFormKey = GlobalKey<FormState>();
}

class CommunityLinks {
  final ESocialLinkType type;
  final TextEditingController controller;

  CommunityLinks({required this.type, required this.controller});

  void dispose() {
    controller.dispose();
  }
}
