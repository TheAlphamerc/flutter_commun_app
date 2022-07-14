part of 'signin_email_cubit.dart';

@freezed
abstract class SigninEmailState with _$SigninEmailState {
  const factory SigninEmailState.initial() = _Initial;
  const factory SigninEmailState.response(
      ESigninEmailState response, String message) = _Response;
  const factory SigninEmailState.verified(UserCredential credential) =
      _Verified;
}

// ignore: constant_identifier_names
enum ESigninEmailState { Error }
