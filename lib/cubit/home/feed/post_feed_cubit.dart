import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_feed_state.dart';
part 'e_post_feed_state.dart';
part 'post_feed_cubit.freezed.dart';

class PostFeedCubit extends Cubit<PostFeedState> with PostFeedCubitMixin {
  final PostRepo postrepo;
  PostFeedCubit(this.postrepo) : super(const PostFeedState.initial()) {
    listenPostToChange = postrepo.listenPostToChange();
    postSubscription = listenPostToChange.listen(postChangeListener);
  }

  /// Fetch posts from firebase firestore
  Future getPosts() async {
    final response = await postrepo.getPostLists("");
    response.fold(
      (l) => updatePostState(null,
          error: "Post not available", estate: EPostFeedState.erorr),
      (r) => updatePostState(r),
    );
  }

  /// Delete posts from firestore
  Future deletePost(PostModel model) async {
    final response = await postrepo.deletePost(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      Utility.cprint("Post deleted");
    });
  }

  Future handleVote(PostModel model, {@required bool isUpVote}) async {
    /// Flag to check if post needed to update on firestore or not.
    /// Restrict user to cast same vote more than one time.
    bool updateRequired = false;

    /// List of all upvotes on post
    final upVotes = model.upVotes ?? <String>[];

    /// List of all downvotes on post
    final downVotes = model.downVotes ?? <String>[];

    // TODO: Remove hardcoded userId and replace with dynamic one
    const String myUserId = "4WRiIdvffacgRfsitXsKF0pQsr52";
    switch (model.myVoteStatus(myUserId)) {
      case PostVoteStatus.downVote:
        {
          /// If user has already cast his downvote and now he wants to change to upvote
          if (isUpVote) {
            downVotes.removeWhere((element) => element == myUserId);
            upVotes.add(myUserId);
            updateRequired = true;
          }
        }

        break;
      case PostVoteStatus.upVote:
        {
          /// If user has already cast his upvote and now he wants to change to downvote
          if (!isUpVote) {
            upVotes.removeWhere((element) => element == myUserId);

            downVotes.add(myUserId);
            updateRequired = true;
          }
        }

        break;
      case PostVoteStatus.noVote:
        {
          updateRequired = true;

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
    if (!updateRequired) {
      return;
    }
    // ignore: parameter_assignments
    model = model.copyWith.call(downVotes: downVotes, upVotes: upVotes);
    final response = await postrepo.handleVote(model);
    response.fold((l) {
      Utility.cprint(l);
    }, (r) {
      onPostUpdate(model);
      Utility.cprint("Voted Sucess");
    });
  }

  void updatePostState(List<PostModel> list,
      {String error, EPostFeedState estate = EPostFeedState.loaded}) {
    emit(PostFeedState.response(
      estate: StateResponse(estate: estate, list: list),
      message: Utility.encodeStateMessage(error),
    ));
  }

  /// Listen to channge in posts collection
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
      onPostDelete(PostModel.fromJson(map));
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map));
    }
  }

  /// Trigger when some post added to firestore
  void onPostAdded(PostModel model) {
    final list = stateFeedList ?? <PostModel>[];
    list.insert(0, model);
    updatePostState(list);
  }

  /// Trigger when some post updated
  void onPostUpdate(PostModel model) {
    final list = stateFeedList;
    if (!list.any((element) => element.id == model.id)) {
      return;
    }
    final oldModel = list.firstWhere((element) => element.id == model.id);
    // ignore: parameter_assignments
    model = model.copyWith.call(
        upVotes: oldModel.upVotes,
        downVotes: oldModel.downVotes,
        shareList: oldModel.shareList);
    final index = list.indexWhere((element) => element.id == model.id);
    list[index] = model;
    updatePostState(list);
  }

  /// Trigger when some posts deleted
  void onPostDelete(PostModel model) {
    final list = List<PostModel>.from(stateFeedList);
    if (list.any((element) => element.id == model.id)) {
      list.removeWhere((element) => element.id == model.id);
      updatePostState(list);
    }
  }

  /// Retrieve posts from state
  List<PostModel> get stateFeedList {
    return state.when(
      initial: () => null,
      response: (estate, message) {
        return estate.list;
      },
    );
  }

  @override
  Future<void> close() {
    dispose();
    return super.close();
  }
}

mixin PostFeedCubitMixin {
  List<PostModel> list;
  Stream<QuerySnapshot> listenPostToChange;
  StreamSubscription<QuerySnapshot> postSubscription;

  void dispose() {
    listenPostToChange.drain();
    postSubscription.cancel();
  }
}
