part of 'create_post_cubit.dart';

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.response(
      {ECreatePostState estate, String message}) = _Response;
}

enum ECreatePostState { saving, saved, eror, fileAdded, fileRemoved }
