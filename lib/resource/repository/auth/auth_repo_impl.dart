part of 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService authService;

  AuthRepoImpl(this.authService);
  @override
  Future<void> verifyPhoneNumber(String phone,
      {Function(VerifyPhoneResponse response) onResponse}) {
    return authService.verifyPhoneNumber(phone, onResponse: onResponse);
  }

  @override
  Future<Either<String, UserCredential>> verifyOTP(
      {String verificationId, String smsCode}) {
    return authService.verifyOTP(
        verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Future<Either<String, bool>> checkUserNameAvailability(String userName) {
    return authService.checkUserNameAvailability(userName);
  }

  @override
  Future<Either<String, bool>> createUserName(String userName) {
    return authService.createUserName(userName);
  }
}
