part of 'post_feed_cubit.dart';

@freezed
abstract class PostFeedState with _$PostFeedState {
  const factory PostFeedState.response({
    required EPostFeedState estate,
    List<PostModel>? list,
    String? message,
  }) = _Response;
}
