import 'package:flutter/material.dart';
import 'home/Home.dart';
import 'login/login.dart';

class AppRoute {
  static const home = 'home';
  static const login = 'login';

  static get all => <String, WidgetBuilder>{
        login: (context) => const LoginPage(),
        home: (context) => const HomePage(),
      };
}
