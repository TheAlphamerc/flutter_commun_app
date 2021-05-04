part of 'signup_email_cubit.dart';

@freezed
abstract class SignupEmailState with _$SignupEmailState {
  const factory SignupEmailState.initial() = _Initial;
  const factory SignupEmailState.response(
      EVerifyEmaileState response, String message) = _Response;
  const factory SignupEmailState.created(UserCredential credential) = _Created;
}

// ignore: constant_identifier_names
enum EVerifyEmaileState { Error }
