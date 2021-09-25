import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/session/session.dart';

import '../../service/auth/firebase_auth_service.dart';
import '../../service/auth/verify_phone_response.dart';

part 'auth_repo_impl.dart';

abstract class AuthRepo {
  Future<void> verifyPhoneNumber(String phone,
      {required Function(VerifyPhoneResponse response) onResponse});

  Future<Either<String, UserCredential>> verifyOTP(
      {required String verificationId, required String smsCode});

  Future<Either<String, UserCredential>> signupWithEmail(
      {required String email, required String password});

  Future<Either<String, UserCredential>> signInWithEmail(
      {required String email, required String password});

  Future<Either<String, bool>> checkUserNameAvailability(String userName);
  Future<Either<String, bool>> checkMobileAvailability(String mobile);
  Future<Either<String, bool>> checkEmailAvailability(String email);
  Future<Either<String, bool>> createUserName(String userName);
  Future<Either<String, UserCredential>> signupWithGoogle();
  Future<Either<String, bool>> createUserAccount(ProfileModel model);

  /// Fetch current firebase user
  Future<Either<String, User>> getFirebaseUser();
  Future<void> logout();
}
