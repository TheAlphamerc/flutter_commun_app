part of 'post_feed_cubit.dart';

@freezed
abstract class PostFeedState with _$PostFeedState {
  const factory PostFeedState.initial() = _Initial;
  const factory PostFeedState.response(
      {@required StateResponse estate, @required String message}) = _Response;
}

class StateResponse {
  final EPostFeedState estate;
  final List<PostModel> list;

  StateResponse({this.estate, this.list});
}
