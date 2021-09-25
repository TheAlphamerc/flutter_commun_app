import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/cubit/post/base/post_base_actions.dart';
import 'package:flutter_commun_app/helper/constant.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/page/page_info.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/service/storage/file_upload_task_response.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'e_post_detail_state.dart';
part 'post_detail_cubit.freezed.dart';
part 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState>
    implements PostBaseActions {
  final PostRepo postRepo;
  PostDetailCubit(this.postRepo, {required String postId})
      : super(
            const PostDetailState.response(estate: EPostDetailState.loading)) {
    commentController = TextEditingController();

    /// Listen to post change
    listenPostToChange = postRepo.listenToPostChange();
    postSubscription = listenPostToChange.listen(postChangeListener);
    getPostDetail(postId).then((value) {
      /// Listen to comments changes
      listenCommentsChange = postRepo.listenToCommentChange(postId);
      commentsSubscription = listenCommentsChange.listen(commentChangeListener);
    });
    progress = BehaviorSubject<String>();
  }
  List<File>? files = [];
  AttachmentType postType = AttachmentType.None;
  late TextEditingController commentController;
  late BehaviorSubject<String> progress;

  Future<void> selectFile(File file, AttachmentType type) async {
    if (postType != type) {
      files = [];
    }
    files = files ?? [];
    files!.add(file);
    postType = type;
    updatePostState(state.post!, message: "Image Added");
  }

  void removeFiles(File file) {
    files!.remove(file);
    updatePostState(state.post!, message: "File Removed");
  }

  @override
  PageInfo? pageInfo = PageInfo(limit: 5);

  @override
  ProfileModel get myUser => getIt<Session>().user!;

  late Stream<QuerySnapshot<Map<String, dynamic>>> listenCommentsChange;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      commentsSubscription;

  @override
  late Stream<QuerySnapshot<Map<String, dynamic>>> listenPostToChange;

  @override
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> postSubscription;

  @override
  Future deletePost(PostModel model) async {
    final response = await postRepo.deletePost(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      updatePostState(model,
          estate: EPostDetailState.delete, message: "Post deleted");
      Utility.cprint("Post deleted");
    });
  }

  @override
  Future handleVote(PostModel model, {required bool isUpVote}) async {
    /// List of all upvotes on post
    final upVotes = model.upVotes ?? <String>[];

    /// List of all downvotes on post
    final downVotes = model.downVotes ?? <String>[];

    final String myUserId = myUser.id!;
    switch (model.myVoteStatus(myUserId)) {
      case PostVoteStatus.downVote:
        {
          /// If user has already cast his downvote and now he wants to change to upvote
          if (isUpVote) {
            downVotes.removeWhere((element) => element == myUserId);
            upVotes.add(myUserId);
          }

          /// If user wants to undo his downvote
          else {
            downVotes.removeWhere((element) => element == myUserId);
          }
        }

        break;
      case PostVoteStatus.upVote:
        {
          /// If user has already cast his upvote and now he wants to change to downvote
          if (!isUpVote) {
            upVotes.removeWhere((element) => element == myUserId);

            downVotes.add(myUserId);
          }

          /// If user wants to undo his upvote
          else {
            upVotes.removeWhere((element) => element == myUserId);
          }
        }

        break;
      case PostVoteStatus.noVote:
        {
          if (isUpVote) {
            /// If user wants to cast upvote
            upVotes.add(myUserId);
          } else {
            /// If user wants to cast downvote
            downVotes.add(myUserId);
          }
        }

        break;
      default:
    }
    // ignore: parameter_assignments
    model = model.copyWith.call(downVotes: downVotes, upVotes: upVotes);
    final response = await postRepo.handleVote(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      updatePostState(model, message: "Voted");
      Utility.cprint("Voted Sucess");
    });
  }

  @override
  void reportPost(PostModel model) {
    // TODO: implement reportPost
  }

  @override
  void onPostDelete(PostModel model) {
    emit(const PostDetailState.response(estate: EPostDetailState.delete));
  }

  @override
  void onPostUpdate(PostModel model) {
    final oldModel = state.post;
    // ignore: parameter_assignments
    model = model.copyWith.call(
        upVotes: oldModel!.upVotes,
        downVotes: oldModel.downVotes,
        shareList: oldModel.shareList);
    updatePostState(model);
  }

  @override
  void postChangeListener(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docChanges.isEmpty) {
      return;
    }
    final map = snapshot.docChanges.first.doc.data();
    if (snapshot.metadata.isFromCache) {
      return;
    }
    if (snapshot.docChanges.first.type == DocumentChangeType.added) {
      var model = PostModel.fromJson(map!);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      onPostDelete(PostModel.fromJson(map!));
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map!));
    }
  }

  void commentChangeListener(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.docChanges.isEmpty) {
      return;
    }
    final map = snapshot.docChanges.first.doc.data();
    if (snapshot.metadata.isFromCache) {
      return;
    }
    if (snapshot.docChanges.first.type == DocumentChangeType.added) {
      var model = PostModel.fromJson(map!);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
      onCommentAdd(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      var model = PostModel.fromJson(map!);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
      onCommentDelete(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      final model = PostModel.fromJson(map!);
      model.copyWith.call(id: snapshot.docChanges.first.doc.id);
      onPostUpdate(model);
    }
  }

  void onCommentDelete(PostModel model) {
    final list = List<PostModel>.from(state.comments!);
    if (list.any((element) => element.id == model.id)) {
      list.removeWhere((element) => element.id == model.id);
      updatePostState(state.post!, comments: list);
    }
  }

  void onCommentAdd(PostModel model) {
    final list = state.comments ?? <PostModel>[];
    list.insert(0, model);
    updatePostState(state.post!, comments: list);
  }

  void onCommentUpdate(PostModel model) {
    final list = state.comments ?? <PostModel>[];
    if (!list.any((element) => element.id == model.id)) {
      return;
    }
    final oldModel = list.firstWhere((element) => element.id == model.id);
    // ignore: parameter_assignments
    model = model.copyWith.call(
        upVotes: oldModel.upVotes,
        downVotes: oldModel.downVotes,
        shareList: oldModel.shareList);
    updatePostState(state.post!, comments: list);
  }

  Future getPostDetail(String postId) async {
    final response = await postRepo.getPostDetail(postId);
    response.fold(
        (l) => updatePostState(null,
            estate: EPostDetailState.error, message: "Post not found"), (r) {
      getPostComments(postId);
      updatePostState(r);
    });
  }

  Future getPostComments(String postId) async {
    final response = await postRepo.getPostComments(postId);
    response.fold(
      (l) => updatePostState(null,
          estate: EPostDetailState.error, message: "Post not found"),
      (r) => updatePostState(state.post!, comments: r),
    );
  }

  Future<void> addComment(BuildContext context) async {
    if (commentController.text.isEmpty) {
      return;
    }

    final imagePath = await _uploadImages(context);
    final model = PostModel(
        description: commentController.text,
        createdBy: myUser.id,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        images: imagePath,
        parentPostId: state.post!.id);

    updatePostState(state.post, estate: EPostDetailState.savingComment);

    /// Save post in firebase firestore db
    final response = await postRepo.createComment(model);
    response.fold(
      (l) {
        Utility.cprint(l);
        updatePostState(state.post,
            estate: EPostDetailState.error,
            message: Utility.encodeStateMessage(l));
      },
      (r) {
        files!.clear();
        commentController.text = "";
        updatePostState(state.post, estate: EPostDetailState.saved);
      },
    );
  }

  /// upload files to firebase storage and get downloadable files path
  Future<List<String>?> _uploadImages(BuildContext context) async {
    final List<String> imagePathList = [];
    if (files != null) {
      // LoaderService loader = LoaderService.instance;
      loader.showLoader(context, message: "Uploading", progress: progress);

      /// Upload files to firebase 1 by 1
      for (final file in files!) {
        progress.sink.add("${files!.indexOf(file) + 1} file");
        final response = await postRepo.uploadFile(file,
            Constants.createFilePath(file.path, folderName: state.post!.id),
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

  Future deleteCommentFromServer(BuildContext context, PostModel model) async {
    final response = await postRepo.deletePost(model);
    response.fold(
      (l) {
        Utility.cprint(l);
      },
      (r) {
        Utility.cprint("Comment deleted");
      },
    );
  }

  void updatePostState(PostModel? model,
      {String? message,
      EPostDetailState estate = EPostDetailState.loaded,
      List<PostModel>? comments}) {
    emit(PostDetailState.response(
        estate: estate,
        message: Utility.encodeStateMessage(message ?? ""),
        post: model ?? state.post!,
        comments: comments ?? state.comments));
  }

  @override
  Future<void> close() async {
    await listenCommentsChange.drain();
    await commentsSubscription.cancel();

    await listenPostToChange.drain();
    await postSubscription.cancel();

    // listenCommentsChange = null;
    // commentsSubscription = null;
    // postSubscription = null;
    // listenPostToChange = null;
    return super.close();
  }
}
