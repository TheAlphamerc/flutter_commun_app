import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/resource/service/verify_phone_response.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  /// Check if username is already exists or not.
  /// Return [True] if username is available to acquire.
  /// Return [False] if username is not available to acquire
  Future<Either<String, bool>> checkUserNameAvailability(
      String userName) async {
    // await Future.delayed(Duration(seconds: 1));
    var query = await FirebaseFirestore.instance
        .collection(CollectionsConstants.profile)
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
        .collection(CollectionsConstants.profile)
        .add({"username": userName});
    return Future.value(Right(true));
  }

  /// Create user account in firebase
  Future<Either<String, UserCredential>> createAcountWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        print(errorMessage);
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
        print(errorMessage);
      }
      return Left(errorMessage);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  /// Check if email is already exists or not.
  /// Return [True] if email is available to acquire.
  /// Return [False] if email is not available to acquire
  Future<Either<String, bool>> checkEmailAvailability(String email) async {
    var query = await FirebaseFirestore.instance
        .collection(CollectionsConstants.email)
        .where("email", isEqualTo: email)
        .get();
    var data = query.docs;
    if (data != null && data.isNotEmpty) {
      return Future.value(Left("Email already Taken"));
    } else {
      return Future.value(Right(true));
    }
  }

  Future<Either<String, UserCredential>> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .onError((error, stackTrace) => null);
      if (userCredential != null) {
        return Right(userCredential);
      } else {
        return Left("Something went wrong");
      }
    } catch (error) {
      print(error);
      return Left("Something went wrong");
    }
  }
}
