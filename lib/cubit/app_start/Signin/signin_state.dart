part of 'signin_cubit.dart';

@freezed
abstract class SigninState with _$SigninState {
  const factory SigninState.initial() = _Initial;
  const factory SigninState.loaded() = _Loaded;
}
