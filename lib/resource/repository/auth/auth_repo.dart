import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../service/firebase_auth_service.dart';
import '../../service/verify_phone_response.dart';

part 'auth_repo_impl.dart';

abstract class AuthRepo {
  Future<void> verifyPhoneNumber(String phone,
      {Function(VerifyPhoneResponse response) onResponse});

  Future<Either<String, UserCredential>> verifyOTP(
      {String verificationId, String smsCode});

  Future<Either<String, UserCredential>> signupWithEmail(
      {String email, String password});

  Future<Either<String, bool>> checkUserNameAvailability(String userName);
  Future<Either<String, bool>> checkEmailAvailability(String email);
  Future<Either<String, bool>> createUserName(String userName);
}
