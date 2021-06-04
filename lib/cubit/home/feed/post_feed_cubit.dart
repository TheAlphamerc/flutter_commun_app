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
      onPostAdded(PostModel.fromJson(map));
    } else if (snapshot.docChanges.first.type == DocumentChangeType.removed) {
      onPostDelete(PostModel.fromJson(map));
    } else if (snapshot.docChanges.first.type == DocumentChangeType.modified) {
      onPostUpdate(PostModel.fromJson(map));
    }
  }

  /// Trigger when some post added to firestore
  void onPostAdded(PostModel model) {
    final list = stateFeedList;
    list.insert(0, model);
    updatePostState(list);
  }

  /// Trigger when some post updated
  void onPostUpdate(PostModel model) {
    final list = stateFeedList;
    final index = list.indexOf(model);
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
