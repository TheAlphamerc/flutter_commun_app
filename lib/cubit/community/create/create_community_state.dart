part of 'create_community_cubit.dart';

@freezed
abstract class CreateCommunityState with _$CreateCommunityState {
  const factory CreateCommunityState.response(ECreateCommunityState estate,
      {String? message, CommunityModel? community}) = _Response;
}
