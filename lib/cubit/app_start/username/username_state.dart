part of 'username_cubit.dart';

@freezed
abstract class UsernameState with _$UsernameState {
  const factory UsernameState.initial() = _Initial;
  const factory UsernameState.created(ProfileModel model) = _Created;
  const factory UsernameState.response(EUsernameState state, String message) =
      _Response;
}
