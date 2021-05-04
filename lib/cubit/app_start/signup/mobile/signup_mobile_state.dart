part of 'signup_mobile_cubit.dart';

@freezed
abstract class SignupMobileState with _$SignupMobileState {
  const factory SignupMobileState.initial() = _Initial;
  const factory SignupMobileState.response(
      EVerifyMobileState response, String message) = _Response;
  const factory SignupMobileState.created(UserCredential credential) = _created;
}

enum EVerifyMobileState {
  // ignore: constant_identifier_names
  OtpSent,
  // ignore: constant_identifier_names
  OtpVerifying,
  // ignore: constant_identifier_names
  OtpVerified,
  // ignore: constant_identifier_names
  Loading,
  // ignore: constant_identifier_names
  VerficationFailed,
  // ignore: constant_identifier_names
  MobileAlreadyInUse,
  // ignore: constant_identifier_names
  Other,
  // ignore: constant_identifier_names
  Timeout
}
