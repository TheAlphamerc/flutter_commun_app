import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'verify_phone_response.freezed.dart';

@freezed
abstract class VerifyPhoneResponse with _$VerifyPhoneResponse {
  const factory VerifyPhoneResponse.verificationCompleted(
      PhoneAuthCredential credential) = _VerificationCompleted;
  const factory VerifyPhoneResponse.verificationFailed(
      FirebaseAuthException e) = _VerificationFailed;
  const factory VerifyPhoneResponse.codeSent(
      String verificationId, int? resendToken) = _CodeSent;
  const factory VerifyPhoneResponse.codeAutoRetrievalTimeout(
      String verificationId) = _CodeAutoRetrievalTimeout;
}
