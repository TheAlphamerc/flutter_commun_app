part of 'community_profile_cubit.dart';

@freezed
abstract class CommunityProfileState with _$CommunityProfileState {
  const factory CommunityProfileState.response(
    EcommunityProfileState estate, {
    CommunityModel? community,
    List<PostModel>? posts,
    String? message,
  }) = _Response;
}
