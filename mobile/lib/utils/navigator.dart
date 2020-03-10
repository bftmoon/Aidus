import 'package:flutter/material.dart';

import 'jwt_util.dart';

class NavKey {
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  static void toLoginPage() async {
    await Jwt.delete();
    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  static void push(route) {
    navigatorKey.currentState.push(route);
  }
}
