part of 'community_feed_cubit.dart';

@freezed
abstract class CommunityFeedState with _$CommunityFeedState {
  const factory CommunityFeedState.response(ECommunityFeedState estate,
      {String? message, List<CommunityModel>? list}) = _Response;
}
