part of 'post_detail_cubit.dart';

@freezed
abstract class PostDetailState with _$PostDetailState {
  const factory PostDetailState.response({
    required EPostDetailState estate,
    String? message,
    PostModel? post,
    List<PostModel>? comments,
  }) = _Response;
}
