import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/service/firebase_auth_service.dart';
import 'package:flutter_commun_app/resource/service/profile/firebase_profile_service.dart';
import 'package:flutter_commun_app/resource/session/shared_prefrence_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;
final logger = Logger();
void setUpDependency() {
  /// Firebase services
  getIt.registerSingleton<FirebaseAuthService>(
      FirebaseAuthService(FirebaseAuth.instance, FirebaseFirestore.instance));
  getIt.registerSingleton<FirebaseProfileService>(FirebaseProfileService(
      FirebaseAuth.instance, FirebaseFirestore.instance));

  /// Repo
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt<FirebaseAuthService>()));
  getIt.registerSingleton<ProfileRepo>(
      ProfileRepoImpl(getIt<FirebaseProfileService>()));
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
}
