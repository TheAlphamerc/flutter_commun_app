import 'package:bloc/bloc.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_feed_state.dart';
part 'e_post_feed_state.dart';
part 'post_feed_cubit.freezed.dart';

class PostFeedCubit extends Cubit<PostFeedState> with PostFeedCubitMixin {
  final PostRepo postrepo;
  PostFeedCubit(this.postrepo) : super(const PostFeedState.initial());

  Future getPosts() async {
    final response = await postrepo.getPostLists("");
    response.fold(
      (l) => null,
      (r) => updatePostList(r),
    );
  }

  void updatePostList(List<PostModel> list) {
    emit(PostFeedState.response(
        estate: StateResponse(estate: EPostFeedState.loaded, list: list),
        message: ""));
  }

  void updateError(String error) {
    emit(
      PostFeedState.response(
          estate: StateResponse(estate: EPostFeedState.loaded, list: list),
          message: error),
    );
  }
}

mixin PostFeedCubitMixin {
  List<PostModel> list;
}
