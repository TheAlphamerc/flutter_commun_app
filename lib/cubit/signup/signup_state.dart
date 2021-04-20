part of 'signup_cubit.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState.initial() = _Initial;
}
