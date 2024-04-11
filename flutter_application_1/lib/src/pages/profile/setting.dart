
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';



class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        title: Text(
          'Setting',
          style: TextStyle(
            color: Color(0xFF146001),
            fontFamily: 'DM Sans-Bold',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 600),
            width: 375,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          resetGlobalVariables();
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF146001),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          'Sign out',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'DM Sans-Bold',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.84,
          ),
        ),
      ),
    );
  }


}

