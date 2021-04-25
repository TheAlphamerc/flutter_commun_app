import 'dart:async';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/resource/service/verify_phone_response.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Verify mobile no. with firebase
  ///
  /// `onResponse` is a callback to return response recieved from firebase sdk
  Future<void> verifyPhoneNumber(String phone,
      {Function(VerifyPhoneResponse response) onResponse}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        onResponse(VerifyPhoneResponse.verificationCompleted(credential));
      },
      verificationFailed: (FirebaseAuthException e) {
        onResponse(VerifyPhoneResponse.verificationFailed(e));
      },
      codeSent: (String verificationId, int resendToken) {
        onResponse(VerifyPhoneResponse.codeSent(verificationId, resendToken));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onResponse(
            VerifyPhoneResponse.codeAutoRetrievalTimeout(verificationId));
      },
    );
  }

  /// Once OTP recieved on mobile, pass otp and verficationId to verifiy otp.
  /// If Otp is verfied successfully then new user will created in firebase.
  /// Creating new user doesn't mean its data is saved in firebase firestore/realtime database.
  Future<Either<String, UserCredential>> verifyOTP(
      {String verificationId, String smsCode}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    String errorMessage;
    // Sign the user in (or link) with the credential
    var userCredential = await auth
        .signInWithCredential(credential)
        .onError((FirebaseAuthException error, stackTrace) {
      log("VerifyOTP", error: error);
      errorMessage = error.message;
      return null;
    });

    return userCredential == null ? Left(errorMessage) : Right(userCredential);
  }
}
