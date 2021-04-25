part of 'signup_cubit.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState.initial() = _Initial;
  const factory SignupState.response(
      VerifyMobileState response, String message) = _Response;
}

enum VerifyMobileState {
  OtpSent,
  OtpVerifying,
  OtpVerified,
  Loading,
  VerficationFailed,
  Other,
  Timeout
}
