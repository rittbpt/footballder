import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_application_1/src/pages/login/changePW.dart';

class OtpPage extends StatefulWidget {
  final String otpValue;
  final String email;

  OtpPage(this.otpValue,this.email);

  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();
  SignUpPageState signUpPageState = SignUpPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFF9F9F9),
      ),
      backgroundColor: Color(0xFFF9F9F9),
      body: Column(
        children: [
          // Bottom layer photo
          Image.asset(
            'assets/Images/otp.png', // Bottom layer photo path
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
            child: signUpPageState.buildTextField(
                'OTP', otpController, 'your OTP'),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF146001),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                checkotp();
                // Handle button press
              },
              child: Text(
                'ENTER',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DM Sans-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.84,
                ),
              ),
            ),
          ),
          // signUpPageState.buildTextField('email', emailController),
        ],
      ),
    );
  }

  void checkotp() {
    try {
      String enteredOTP = otpController.text.trim();
      if (enteredOTP == widget.otpValue) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage(widget.email)),
        );
      } else {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text('Error'),
            content: Text('Wrong OTP.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Color(0xFF146001), // Set the text color here
                ),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
