import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/service/firebase_auth_service.dart';
import 'package:flutter_commun_app/resource/session/shared_prefrence_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;
final logger = Logger();
void setUpDependency() {
  getIt.registerSingleton<FirebaseAuthService>(
      FirebaseAuthService(FirebaseAuth.instance, FirebaseFirestore.instance));
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt<FirebaseAuthService>()));
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
}
