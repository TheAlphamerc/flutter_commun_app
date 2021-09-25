import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/service/auth/verify_phone_response.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_mobile_cubit.freezed.dart';
part 'signup_mobile_state.dart';

class SignupMobileCubit extends Cubit<SignupMobileState> {
  final AuthRepo authRepo;
  SignupMobileCubit(this.authRepo) : super(const SignupMobileState.initial()) {
    phone = TextEditingController();
  }
  String? verificationId;
  late TextEditingController phone;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserCredential? credential;

  Future continueWithPhone(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    assert(phone != null);
    loader.showLoader(context, message: "Sending OTP");

    /// Make sure to replace `+1` with your country code
    final no = "+1${phone.text}";

    /// Starts a phone number verification process for the given phone number
    await authRepo.verifyPhoneNumber(no,
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
      Utility.cprint("[verifyPhoneNumberListener] verification completed");
      emit(SignupMobileState.response(EVerifyMobileState.OtpVerified,
          context.locale.verification_completed));
    },

        /// [verificationFailed] Triggered when an error occurred during phone number verification.
        /// A [FirebaseAuthException] is provided when this is triggered.
        verificationFailed: (state) {
      Utility.cprint("[verifyPhoneNumberListener] Failed");
      emit(SignupMobileState.response(EVerifyMobileState.VerficationFailed,
          context.locale.varification_failed));
    },

        /// Triggered when an SMS has been sent to the users phone,
        /// And will include a [verificationId] and [forceResendingToken].
        codeSent: (state) {
      verificationId = state.verificationId;
      Utility.cprint("[verifyPhoneNumberListener] Code sent");
      emit(SignupMobileState.response(
          EVerifyMobileState.OtpSent, context.locale.otp_sent_to_phone));
    },

        /// Triggered when SMS auto-retrieval times out and provide a [verificationId].
        codeAutoRetrievalTimeout: (state) {
      Utility.cprint("[verifyPhoneNumberListener] Timeout");
      emit(const SignupMobileState.response(
          EVerifyMobileState.Timeout, "Timeout"));
    });
  }

  /// Verify otp
  Future<void> verifyOTP(BuildContext context, String smsCode) async {
    /// Display loader on screeen while verifying Otp
    loader.showLoader(context, message: context.locale.verifying);
    final user = await authRepo.verifyOTP(
        smsCode: smsCode, verificationId: verificationId!);

    /// Hide loader
    loader.hideLoader();
    user.fold((l) {
      /// If otp verifacation failed
      emit(SignupMobileState.response(
          EVerifyMobileState.VerficationFailed, Utility.encodeStateMessage(l)));
    }, (r) {
      /// If otp verifacation success
      credential = r;
      emit(SignupMobileState.response(
          EVerifyMobileState.OtpVerified, context.locale.otpVerified));
    });
  }

  Future checkMobileAvailability(BuildContext context) async {
    final response =
        await authRepo.checkMobileAvailability(credential!.user!.phoneNumber!);
    response.fold(
        (l) => emit(SignupMobileState.response(
            EVerifyMobileState.MobileAlreadyInUse,
            Utility.encodeStateMessage(
                context.locale.account_already_existed_with_mobile))),
        (r) => emit(SignupMobileState.created(credential!)));
  }

  @override
  Future<void> close() {
    phone.dispose();
    return super.close();
  }
}
