import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/bloc/login/login_bloc.dart';
import 'package:flutter_application_1/src/pages/SplashScreen.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';
import 'package:flutter_application_1/src/pages/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/src/pages/auth_provider.dart'; // Import the AuthProvider class

class footballder extends StatelessWidget {
  const footballder({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()), // Provide an instance of AuthProvider
        BlocProvider(create: (context) => LoginBloc()), // Provide an instance of LoginBloc
      ],
      child: MaterialApp(
        title: 'Your App',
        routes: AppRoute.all,
        home: SplashScreen(),
      ),
    );
  }
}
