import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_commun_app/cubit/post/base/post_base_actions.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail_state.dart';
part 'e_post_detail_state.dart';
part 'post_detail_cubit.freezed.dart';

class PostDetailCubit extends Cubit<PostDetailState>
    implements PostBaseActions {
  final PostRepo postRepo;
  PostDetailCubit(this.postRepo, {@required String postId})
      : super(
            const PostDetailState.response(estate: EPostDetailState.loading)) {
    listenPostToChange = postRepo.listenPostToChange();
    postSubscription = listenPostToChange.listen(postChangeListener);
    getPostDetail(postId);
  }

  @override
  ProfileModel get myUser => getIt<Session>().user;

  @override
  Stream<QuerySnapshot> listenPostToChange;

  @override
  StreamSubscription<QuerySnapshot> postSubscription;

  @override
  Future deletePost(PostModel model) async {
    final response = await postRepo.deletePost(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      updatePostModel(model,
          estate: EPostDetailState.delete, message: "Post deleted");
      Utility.cprint("Post deleted");
    });
  }

  @override
  Future handleVote(PostModel model, {bool isUpVote}) async {
    /// List of all upvotes on post
    final upVotes = model.upVotes ?? <String>[];

    /// List of all downvotes on post
    final downVotes = model.downVotes ?? <String>[];

    final String myUserId = myUser.id;
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
      updatePostModel(model, message: "Voted");
      Utility.cprint("Voted Sucess");
    });
  }

  @override
  void onPostDelete(PostModel model) {
    emit(const PostDetailState.response(estate: EPostDetailState.delete));
  }

  @override
  void onPostUpdate(PostModel model) {
    final oldModel = statePost;
    // ignore: parameter_assignments
    model = model.copyWith.call(
        upVotes: oldModel.upVotes,
        downVotes: oldModel.downVotes,
        shareList: oldModel.shareList);
    updatePostModel(model);
  }

  @override
  void postChangeListener(QuerySnapshot snapshot) {
    if (snapshot.docChanges.isEmpty) {
      return;
    }
    final map = snapshot.docChanges.first.doc.data();
    if (snapshot.metadata.isFromCache) {
      return;
    }
    if (snapshot.docChanges.first.type == DocumentChangeType.added) {
      var model = PostModel.fromJson(map);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      onPostDelete(PostModel.fromJson(map));
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map));
    }
  }

  void updatePostModel(PostModel model,
      {String message, EPostDetailState estate = EPostDetailState.loaded}) {
    emit(PostDetailState.response(
        estate: estate,
        message: Utility.encodeStateMessage(message),
        post: model));
  }

  Future getPostDetail(String postId) async {
    final response = await postRepo.getPostDetail(postId);
    response.fold(
      (l) => updatePostModel(null,
          estate: EPostDetailState.erorr, message: "Post not found"),
      (r) => updatePostModel(r),
    );
  }

  PostModel get statePost {
    return state.when(response: (estate, message, model) => model);
  }

  @override
  void dispose() {
    postSubscription.cancel();
    listenPostToChange.drain();
  }
}
