import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/helper/collections_constants.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
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
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    String errorMessage;
    // Sign the user in (or link) with the credential
    final userCredential = await auth
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
    final query = await firestore
        .collection(CollectionsConstants.profile)
        .where("username", isEqualTo: userName)
        .get();
    final data = query.docs;
    if (data != null && data.isNotEmpty) {
      return Future.value(const Left("User name already in use"));
    } else {
      return Future.value(const Right(true));
    }
  }

  Future<Either<String, bool>> checkMobileAvailability(
      String phoneNumber) async {
    final query = await firestore
        .collection(CollectionsConstants.profile)
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();
    final data = query.docs;
    if (data != null && data.isNotEmpty) {
      return Future.value(const Left("Mobile name already in use"));
    } else {
      return Future.value(const Right(true));
    }
  }

  Future<Either<String, bool>> createUserName(String userName) async {
    await firestore
        .collection(CollectionsConstants.profile)
        .add({"username": userName});
    return Future.value(const Right(true));
  }

  /// Create user account in firebase
  Future<Either<String, UserCredential>> createAcountWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        // print(errorMessage);
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
        // print(errorMessage);
      }
      return Left(errorMessage);
    } catch (e) {
      // print(e);
      return Left(e.toString());
    }
  }

  /// Check if email is already exists or not.
  /// Return [True] if email is available to acquire.
  /// Return [False] if email is not available to acquire
  Future<Either<String, bool>> checkEmailAvailability(String email) async {
    final query = await firestore
        .collection(CollectionsConstants.profile)
        .where("email", isEqualTo: email)
        .get();
    final data = query.docs;
    if (data != null && data.isNotEmpty) {
      return Future.value(const Left("Email already Taken"));
    } else {
      return Future.value(const Right(true));
    }
  }

  Future<Either<String, UserCredential>> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
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
        return const Left("Something went wrong");
      }
    } catch (error) {
      // print(error);
      return const Left("Something went wrong");
    }
  }

  /// Save user profile in firebase firestore database
  /// Saving a profile means creating a new user
  Future<Either<String, bool>> createUserAccount(ProfileModel model) async {
    await firestore
        .collection(CollectionsConstants.profile)
        .add(model.toJson());
    return Future.value(const Right(true));
  }
}
