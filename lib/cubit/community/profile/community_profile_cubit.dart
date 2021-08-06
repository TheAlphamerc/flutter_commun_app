import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_commun_app/cubit/post/base/post_base_actions.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/community/community_feed_repo.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_profile_state.dart';
part 'e_community_profile_state.dart';
part 'community_profile_cubit.freezed.dart';

class CommunityProfileCubit extends Cubit<CommunityProfileState>
    with PostOperationMixin {
  final CommunityFeedRepo communRepo;
  final PostRepo postRepo;
  CommunityProfileCubit(this.communRepo, this.postRepo,
      {CommunityModel community, String communityId})
      : super(const CommunityProfileState.response(
            EcommunityProfileState.initial)) {
    if (community != null) {
      updateState(community: community);
      getCommunityPost(communityId).then((value) => null);
    } else {
      getCommunityById(communityId).then((value) => null);
    }

    listenPostToChange = postRepo.listenToPostChange();
    postSubscription = listenPostToChange.listen(postChangeListener);

    init(
      onPostAdded: _onPostAdded,
      onPostDeleted: _onPostDelete,
      onPostUpdated: updatePost,
      postRepo: postRepo,
    );
  }

  Future getCommunityById(String communityId) async {
    final response = await communRepo.getCommunityById(communityId);
    response.fold(
      (l) => null,
      (r) async {
        updateState(community: r);
        await getCommunityPost(communityId);
      },
    );
  }

  Future getCommunityPost(String communityId) async {
    final response = await postRepo.getCommunityPosts(communityId);
    response.fold(
      (l) => null,
      (r) {
        updateState(posts: r);
      },
    );
  }

  /// Trigger when some post added to firestore
  void _onPostAdded(PostModel model) {
    final list = state.posts ?? <PostModel>[];
    list.insert(0, model);
    updateState(posts: list);
  }

  /// Trigger when some post updated

  // void _onPostUpdate(PostModel model) {
  //   final list = state.posts;
  //   if (!list.any((element) => element.id == model.id)) {
  //     return;
  //   }
  //   final oldModel = list.firstWhere((element) => element.id == model.id);
  //   // ignore: parameter_assignments
  //   model = model.copyWith.call(
  //       upVotes: oldModel.upVotes,
  //       downVotes: oldModel.downVotes,
  //       shareList: oldModel.shareList);
  //   updatePost(model);
  // }

  /// Trigger when some posts deleted
  void _onPostDelete(PostModel model) {
    final list = List<PostModel>.from(state.posts);
    if (list.any((element) => element.id == model.id)) {
      list.removeWhere((element) => element.id == model.id);
      updateState(posts: list);
    }
  }

  void updatePost(PostModel model) {
    final list = state.posts;
    if (state.posts.any((element) => element.id == model.id)) {
      final index = state.posts.indexWhere((element) => element.id == model.id);
      list[index] = model;
      updateState(posts: list);
    }
  }

  void updateState({
    EcommunityProfileState estate = EcommunityProfileState.loaded,
    CommunityModel community,
    List<PostModel> posts,
    String message,
  }) {
    emit(
      CommunityProfileState.response(
        estate,
        community: community ?? state.community,
        posts: posts ?? state.posts,
        message: Utility.encodeStateMessage(message ?? ""),
      ),
    );
  }

  @override
  Future<void> close() {
    listenPostToChange.drain();
    postSubscription.cancel();
    return super.close();
  }
}

class PostOperationMixin implements PostBaseActions {
  PostRepo _postRepo;
  Function(PostModel model) onPostUpdated;
  Function(PostModel model) onPostDeleted;
  Function(PostModel model) onPostAdded;

  /// Initilise mixin parameters
  void init({
    PostRepo postRepo,
    Function(PostModel model) onPostUpdated,
    Function(PostModel model) onPostDeleted,
    Function(PostModel model) onPostAdded,
  }) {
    _postRepo = postRepo;
    this.onPostUpdated = onPostUpdated;
    this.onPostDeleted = onPostDeleted;
    this.onPostAdded = onPostAdded;
  }

  @override
  Stream<QuerySnapshot> listenPostToChange;

  @override
  StreamSubscription<QuerySnapshot> postSubscription;

  /// Loggedin user's profile
  @override
  ProfileModel get myUser => getIt<Session>().user;

  /// Delete posts from firestore
  @override
  Future deletePost(PostModel model) async {
    final response = await _postRepo.deletePost(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      Utility.cprint("Post deleted");
    });
  }

  @override
  Future handleVote(PostModel model, {@required bool isUpVote}) async {
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
    final response = await _postRepo.handleVote(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      onPostUpdate(model);
      Utility.cprint("Voted Sucess");
    });
  }

  @override
  void reportPost(PostModel model) {
    // TODO: implement reportPost
  }

  /// Listen to channge in posts collection
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
      onPostAdded(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      var model = PostModel.fromJson(map);
      model = model.copyWith.call(id: snapshot.docChanges.first.doc.id);
      onPostDelete(model);
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map));
    }
  }

  /// Trigger when some post updated
  @override
  void onPostUpdate(PostModel model) {
    onPostUpdated(model);
  }

  /// Trigger when some posts deleted
  @override
  void onPostDelete(PostModel model) {
    onPostDelete(model);
  }
}
