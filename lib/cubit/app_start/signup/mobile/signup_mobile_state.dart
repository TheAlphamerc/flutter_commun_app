part of 'signup_mobile_cubit.dart';

@freezed
abstract class SignupMobileState with _$SignupMobileState {
  const factory SignupMobileState.initial() = _Initial;
  const factory SignupMobileState.response(
      EVerifyMobileState response, String message) = _Response;
}

enum EVerifyMobileState {
  OtpSent,
  OtpVerifying,
  OtpVerified,
  Loading,
  VerficationFailed,
  Other,
  Timeout
}
