import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/service/firebase_auth_service.dart';
import 'package:flutter_commun_app/resource/service/verify_phone_response.dart';
import 'package:flutter_commun_app/ui/widget/overlay_loader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState.initial()) {
    phone = TextEditingController();
    loader = CustomLoader();
  }
  String verificationId;
  TextEditingController phone;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CustomLoader loader;

  Future continueWithPhone(BuildContext context) async {
    var isValid = formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    assert(phone != null);

    /// Make sure to replace `+91` with your country code
    final no = "+91${phone.text}";

    /// Starts a phone number verification process for the given phone number
    await getIt<FirebaseAuthService>().verifyPhoneNumber(no,
        onResponse: (response) => verifyPhoneNumberListener(context, response));
  }

  /// Listener for mobile verification response
  void verifyPhoneNumberListener(
      BuildContext context, VerifyPhoneResponse data) {
    loader.hideLoader();
    data.map(

        /// [verificationCompleted] Triggered when an SMS is auto-retrieved
        /// or the phone number has been instantly verified.
        /// The callback will receive an [PhoneAuthCredential]
        /// that can be passed to [signInWithCredential] or [linkWithCredential].
        verificationCompleted: (state) {
      print("[verifyPhoneNumberListener] verification completed");
      emit(SignupState.response(VerifyMobileState.OtpVerified,
          context.locale.verification_completed));
    },

        /// [verificationFailed] Triggered when an error occurred during phone number verification.
        /// A [FirebaseAuthException] is provided when this is triggered.
        verificationFailed: (state) {
      print("[verifyPhoneNumberListener] Failed");
      emit(SignupState.response(VerifyMobileState.VerficationFailed,
          context.locale.varification_failed));
    },

        /// Triggered when an SMS has been sent to the users phone,
        /// And will include a [verificationId] and [forceResendingToken].
        codeSent: (state) {
      verificationId = state.verificationId;
      print("[verifyPhoneNumberListener] Code sent");
      emit(SignupState.response(
          VerifyMobileState.OtpSent, context.locale.otp_sent_to_phone));
    },

        /// Triggered when SMS auto-retrieval times out and provide a [verificationId].
        codeAutoRetrievalTimeout: (state) {
      print("[verifyPhoneNumberListener] Timeout");
      emit(SignupState.response(VerifyMobileState.Timeout, "Timeout"));
    });
  }

  /// Verify otp
  Future<void> verifyOTP(BuildContext context, String smsCode) async {
    /// Display loader on screeen while verifying Otp
    loader.showLoader(context, message: context.locale.verifying);
    var user = await getIt<FirebaseAuthService>()
        .verifyOTP(smsCode: smsCode, verificationId: verificationId);

    /// Hide loader
    loader.hideLoader();
    user.fold((l) {
      /// If otp verifacation failed
      emit(SignupState.response(VerifyMobileState.VerficationFailed, l));
    }, (r) {
      /// If otp verifacation success‰
      emit(SignupState.response(
          VerifyMobileState.OtpVerified, context.locale.otpVerified));
    });
  }

  @override
  Future<void> close() {
    phone.dispose();
    return super.close();
  }
}
