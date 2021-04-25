import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/resource/service/verify_phone_response.dart';

class FirebaseAuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseAuthService(this.auth, this.firestore);

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

  Future<Either<String, bool>> checkUserNameAvailability(
      String userName) async {
    // await Future.delayed(Duration(seconds: 1));
    var query = await FirebaseFirestore.instance
        .collection(CollectionsConstants.username)
        .where("username", isEqualTo: userName)
        .get();
    var data = query.docs;
    if (data != null && data.isNotEmpty) {
      return Future.value(Left("User name already in use"));
    } else {
      return Future.value(Right(true));
    }
  }

  Future<Either<String, bool>> createUserName(String userName) async {
    await Future.delayed(Duration(seconds: 1));
    await FirebaseFirestore.instance
        .collection(CollectionsConstants.username)
        .add({"username": userName});
    return Future.value(Right(true));
  }
}
