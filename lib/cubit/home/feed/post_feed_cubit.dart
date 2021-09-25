import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_commun_app/cubit/post/base/post_base_actions.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/page/page_info.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_feed_state.dart';
part 'e_post_feed_state.dart';
part 'post_feed_cubit.freezed.dart';

class PostFeedCubit extends Cubit<PostFeedState> implements PostBaseActions {
  final PostRepo postrepo;
  PostFeedCubit(this.postrepo)
      : super(const PostFeedState.response(estate: EPostFeedState.initial)) {
    listenPostToChange = postrepo.listenToPostChange();
    postSubscription = listenPostToChange.listen(postChangeListener);
  }

  @override
  PageInfo? pageInfo = PageInfo(limit: 5);

  @override
  late Stream<QuerySnapshot<Map<String, dynamic>>> listenPostToChange;

  @override
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> postSubscription;

  /// Loggedin user's profile
  @override
  ProfileModel get myUser => getIt<Session>().user!;

  Future getMorePosts() async {
    if (pageInfo!.hasMorePosts!) {
      updatePostState(state.list, estate: EPostFeedState.loadingMore);
      await getPosts();
    }
  }

  /// Fetch posts from firebase firestore
  Future getPosts() async {
    final response = await postrepo.getPostLists("", pageInfo!);
    response.fold(
        (l) => updatePostState(null,
            error: "Post not available", estate: EPostFeedState.erorr), (r) {
      var postList = state.list;
      pageInfo = pageInfo!.copyWith(lastSnapshot: r.value2);
      if (postList == null) {
        /// Initilised post list for the first time
        postList = r.value1;
      } else {
        /// Add posts in existing post list
        postList.addAll(r.value1);
      }

      /// Check if all posts are fetched
      if (!(r.value1.notNullAndEmpty && r.value1.length == pageInfo!.limit)) {
        pageInfo = pageInfo!.copyWith(hasMorePosts: false);
        logger.i("All posts Fetched");
      }
      updatePostState(postList);
    });
  }

  /// Delete posts from firestore
  @override
  Future deletePost(PostModel model) async {
    final response = await postrepo.deletePost(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
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
    final response = await postrepo.handleVote(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      updatePost(model);
      Utility.cprint("Voted Sucess");
    });
  }

  @override
  void reportPost(PostModel model) {
    // TODO: implement reportPost
  }

  /// Listen to channge in posts collection
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
      onPostAdded(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      var model = PostModel.fromJson(map!);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
      onPostDelete(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map!));
    }
  }

  /// Trigger when some post added to firestore
  void onPostAdded(PostModel model) {
    final list = state.list ?? <PostModel>[];
    list.insert(0, model);
    updatePostState(list);
  }

  /// Trigger when some post updated
  @override
  void onPostUpdate(PostModel model) {
    final list = state.list;
    if (!list!.any((element) => element.id == model.id)) {
      return;
    }
    final oldModel = list.firstWhere((element) => element.id == model.id);
    // ignore: parameter_assignments
    model = model.copyWith.call(
        upVotes: oldModel.upVotes,
        downVotes: oldModel.downVotes,
        shareList: oldModel.shareList);
    updatePost(model);
  }

  /// Trigger when some posts deleted
  @override
  void onPostDelete(PostModel model) {
    final list = List<PostModel>.from(state.list!);
    if (list.any((element) => element.id == model.id)) {
      list.removeWhere((element) => element.id == model.id);
      updatePostState(list);
    }
  }

  void updatePost(PostModel model) {
    final list = state.list;
    if (state.list!.any((element) => element.id == model.id)) {
      final index = state.list!.indexWhere((element) => element.id == model.id);
      list![index] = model;
      updatePostState(list);
    }
  }

  void updatePostState(List<PostModel>? list,
      {String? error, EPostFeedState? estate = EPostFeedState.loaded}) {
    emit(PostFeedState.response(
      estate: estate ?? state.estate,
      list: list ?? state.list,
      message: Utility.encodeStateMessage(error ?? ""),
    ));
  }

  @override
  Future<void> close() {
    listenPostToChange.drain();
    postSubscription.cancel();
    return super.close();
  }
}
