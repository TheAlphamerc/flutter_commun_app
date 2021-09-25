part of 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService authService;

  AuthRepoImpl(this.authService);
  @override
  Future<void> verifyPhoneNumber(String phone,
      {required Function(VerifyPhoneResponse response) onResponse}) {
    return authService.verifyPhoneNumber(phone, onResponse: onResponse);
  }

  @override
  Future<Either<String, UserCredential>> verifyOTP(
      {required String verificationId, required String smsCode}) {
    return authService.verifyOTP(
        verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Future<Either<String, bool>> checkUserNameAvailability(String userName) {
    return authService.checkUserNameAvailability(userName);
  }

  @override
  Future<Either<String, bool>> checkMobileAvailability(String mobile) {
    return authService.checkMobileAvailability(mobile);
  }

  @override
  Future<Either<String, bool>> createUserName(String userName) {
    return authService.createUserName(userName);
  }

  @override
  Future<Either<String, UserCredential>> signupWithEmail(
      {required String email, required String password}) {
    return authService.createAcountWithEmailAndPassword(email, password);
  }

  @override
  Future<Either<String, UserCredential>> signInWithEmail(
      {required String email, required String password}) {
    return authService.signInWithEmail(email, password);
  }

  @override
  Future<Either<String, bool>> checkEmailAvailability(String email) {
    return authService.checkEmailAvailability(email);
  }

  @override
  Future<Either<String, UserCredential>> signupWithGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Future<Either<String, bool>> createUserAccount(ProfileModel model) async {
    final response = await authService.createUserAccount(model);
    return response.fold((l) => Left(l), (r) async {
      await getIt<Session>().saveUserProfile(model);
      return Right(r);
    });
  }

  @override
  Future<Either<String, User>> getFirebaseUser() async {
    final response = await authService.getFirebaseUser();
    return response.fold((l) => Left(l), (r) async {
      return Right(r);
    });
  }

  @override
  Future<void> logout() async {
    return authService.logout();
  }
}
