import 'package:flutter/material.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'navigator.dart';

class AppRoute {
  static const home = 'home';
  static const login = 'login';

  static get all => <String, WidgetBuilder>{
        login: (context) => const LoginPage(),
        home: (context) =>  NavigatorPage(),
      };
}
