import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';
import 'package:flutter_application_1/src/pages/routes.dart';

class test extends StatelessWidget {
  const test({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Rit test", routes: AppRoute.all, home: LoginPage());
  }
}
