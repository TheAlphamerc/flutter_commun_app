part of 'create_post_cubit.dart';

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState.response(
      {ECreatePostState? estate,
      String? message,
      CommunityModel? community}) = _Response;
}

enum ECreatePostState { initial, saving, saved, eror, fileAdded, fileRemoved }
