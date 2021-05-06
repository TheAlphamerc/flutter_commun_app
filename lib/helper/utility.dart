import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/locator.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom;

class Utility {
  static void displaySnackbar(BuildContext context,
      {String msg = "Feature is under development",
      GlobalKey<ScaffoldState> key}) {
    final snackBar = SnackBar(content: Text(msg));
    if (key != null && key.currentState != null) {
      // key.currentState.hideCurrentSnackBar();
      // key.currentState.showSnackBar(snackBar);
      ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar();
      ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar();
      ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
    }
  }

  static String encodeStateMessage(String message) {
    if (message != null) {
      final mess = "$message ##${DateTime.now().microsecondsSinceEpoch}";
      return mess;
    }
    return "";
  }

  static String decodeStateMessage(String message) {
    if (message != null && message.contains("##")) {
      return message.split("##")[0];
    }
    return "";
  }

  static void cprint(String message,
      {dynamic error, String label, StackTrace stackTrace}) {
    if (kDebugMode) {
      // ignore: avoid_print
      if (error != null) {
        logger.e(label ?? 'Log', error, stackTrace);
      } else {
        // ignore: avoid_print
        print("[${label ?? 'Log'}] $message");
      }
    }
  }
}
