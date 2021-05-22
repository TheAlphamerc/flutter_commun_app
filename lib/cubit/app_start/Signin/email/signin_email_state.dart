part of 'signin_email_cubit.dart';

@freezed
abstract class SigninEmailState with _$SigninEmailState {
  const factory SigninEmailState.initial() = _Initial;
  const factory SigninEmailState.response(
      ESigninEmailState response, String message) = _Response;
  const factory SigninEmailState.verfied(UserCredential credential) = _Verfied;
}

// ignore: constant_identifier_names
enum ESigninEmailState { Error }
