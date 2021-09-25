import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/ui/app/commun_app.dart';
import 'package:flutter_commun_app/ui/pages/app_start/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpDependency();

  const app = CommunApp(home: SplashPage());

  WidgetsFlutterBinding.ensureInitialized();
  // FlutterError.onError = (details) {
  //   logger.e(details.exceptionAsString(), null, details.stack);
  // };

  runZonedGuarded(
    () => runApp(app),
    (error, stackTrace) =>
        Utility.cprint("App", error: error, stackTrace: stackTrace),
  );
}
