import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/bloc/login/login_bloc.dart';
import 'package:flutter_application_1/src/pages/SplashScreen.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';
import 'package:flutter_application_1/src/pages/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class footballder extends StatelessWidget {
  const footballder({super.key});
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider(create: (context) => LoginBloc());

    return MultiBlocProvider(
        providers: [loginBloc],
        child: MaterialApp(
            title: "Rit test", routes: AppRoute.all, home: SplashScreen()));
  }
}
