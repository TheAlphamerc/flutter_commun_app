import 'package:flutter_commun_app/resource/service/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;
final logger = Logger();
void setUpDependency() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
}
