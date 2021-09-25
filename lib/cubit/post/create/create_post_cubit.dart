import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/constant.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'create_post_cubit.freezed.dart';
part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> with CreatePostCubitMixin {
  final PostRepo postRepo;
  CreatePostCubit({required this.postRepo, CommunityModel? community})
      : super(
            const CreatePostState.response(estate: ECreatePostState.initial)) {
    description = TextEditingController();
    progress = BehaviorSubject<String>();
    setCommunity(community);
  }
  void setCommunity(CommunityModel? community) {
    if (community == null) {
      return;
    }
    updateState(ECreatePostState.fileAdded,
        message: "Community updated", model: community);
  }

  /// Add file
  void addFiles(List<File> list) {
    files ??= <File>[];
    files!.addAll(list);
    updateState(ECreatePostState.fileAdded, message: "File Added");
  }

  /// Remove file
  void removeFile(File file) {
    files!.remove(file);
    if (files!.isEmpty) {
      files = null;
    }

    updateState(ECreatePostState.fileRemoved, message: "File Removed");
  }

  Future<void> createPost(BuildContext context) async {
    if (description.text.isEmpty) {
      return;
    }

    final imagePath = await _uploadImages(context);
    final model = PostModel(
        description: description.text,
        createdBy: user.id,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        images: imagePath,
        communityId: state.community!.id,
        communityAvatar: state.community!.avatar,
        communityName: state.community!.name,
        user: ProfileModel(
          id: user.id,
          name: user.name,
          photoURL: user.photoURL,
          isVerified: user.isVerified,
          username: user.username,
        ));

    updateState(ECreatePostState.saving);

    /// Save post in firebase firestore db
    final response = await postRepo.createPost(model);
    response.fold(
      (l) {
        Utility.cprint(l);
        updateState(ECreatePostState.eror, message: "Post created failed");
      },
      (r) {
        updateState(ECreatePostState.saved,
            message: "Post created successfully");
      },
    );
  }

  /// upload files to firebase storage and get downloadable files path
  Future<List<String>?> _uploadImages(BuildContext context) async {
    final List<String> imagePathList = [];
    if (files != null) {
      loader.showLoader(context, message: "Uploading", progress: progress);

      /// Upload files to firebase 1 by 1
      for (final file in files!) {
        progress.sink.add("${files!.indexOf(file) + 1} file");
        final response = await postRepo.uploadFile(
            file,
            Constants.createFilePath(file.path,
                folderName: Constants.postImagePath),
            onFileUpload: onFileUpload);
        progress.sink.add("");
        response.fold(
          (l) => null,
          (r) => imagePathList.add(r),
        );
      }
      loader.hideLoader();

      return imagePathList;
    } else {
      return null;
    }
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

  void updateState(ECreatePostState estate,
      {String? message, CommunityModel? model}) {
    emit(CreatePostState.response(
        estate: estate,
        community: model ?? state.community,
        message: Utility.encodeStateMessage(message ?? "")));
  }

  @override
  Future<void> close() {
    dispose();
    return super.close();
  }
}

mixin CreatePostCubitMixin {
  late TextEditingController description;
  List<File>? files;
  late BehaviorSubject<String> progress;
  ProfileModel get user => getIt<Session>().user!;
  void dispose() {
    progress.drain();
    description.dispose();
  }
}
