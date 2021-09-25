import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<T?> push<T extends Object>(Route<T> route) {
    return navigatorKey.currentState!.push(route);
  }

  Future<T?> pushAndRemoveUntil<T extends Object>(Route<T> route) {
    return navigatorKey.currentState!
        .pushAndRemoveUntil(route, (route) => false);
  }

  dynamic goBack() {
    return navigatorKey.currentState!.pop();
  }

  // void showLoader(CustomLoader loader) {
  //   loader.showLoader(navigatorKey.currentContext);
  // }

  NavigatorState get navigattor => navigatorKey.currentState!;
}
