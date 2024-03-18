import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds and then navigate to the login page
    Timer(
      Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF30702D), // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // Footballer wrapper
                height: 812,
                width: 375,
                color: Color(0xFF30702D),
                child: Stack(
                  children: [
                    Positioned(
                      // Footballer image
                      top: 290,
                      left: 0,
                      child: Image.asset(
                        'assets/Images/splash.png',
                        height: 231,
                        width: 375,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
