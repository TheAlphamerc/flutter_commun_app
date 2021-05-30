import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/resource/service/feed/firebase_post_service.dart';
import 'package:flutter_commun_app/resource/service/navigation/navigation_service.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/service/auth/firebase_auth_service.dart';
import 'package:flutter_commun_app/resource/service/profile/firebase_profile_service.dart';
import 'package:flutter_commun_app/resource/service/storage/firebase_storage_service.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:flutter_commun_app/resource/session/session_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final getIt = GetIt.instance;
final logger = Logger();
void setUpDependency() {
  /// Firebase services
  getIt.registerSingleton<FirebaseAuthService>(
      FirebaseAuthService(FirebaseAuth.instance, FirebaseFirestore.instance));
  getIt.registerSingleton<FirebaseProfileService>(FirebaseProfileService(
      FirebaseAuth.instance, FirebaseFirestore.instance));
  getIt.registerSingleton<FirebaseStorageService>(
      FirebaseStorageService(firebase_storage.FirebaseStorage.instance));
  getIt.registerSingleton<FirebasePostService>(
      FirebasePostService(FirebaseFirestore.instance));

  /// Flutter service
  getIt.registerSingleton<NavigationService>(NavigationService());

  /// Repo
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt<FirebaseAuthService>()));
  getIt.registerSingleton<ProfileRepo>(ProfileRepoImpl(
      getIt<FirebaseProfileService>(), getIt<FirebaseStorageService>()));
  getIt.registerSingleton<Session>(SessionImpl());
  getIt.registerSingleton<PostRepo>(PostRepoImpl(
      getIt<FirebasePostService>(), getIt<FirebaseStorageService>()));
}
