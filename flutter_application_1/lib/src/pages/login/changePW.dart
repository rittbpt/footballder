import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';
import 'package:flutter_application_1/src/pages/login/otp.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_application_1/src/pages/login/otp.dart';
import 'package:dio/dio.dart';


class ChangePasswordPage extends StatefulWidget {

  final String email;

  ChangePasswordPage(this.email);
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  SignUpPageState signUpPageState = SignUpPageState();

  Dio dio = Dio();

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
          SizedBox(height: 10),
          Image.asset(
            'assets/Images/changePW.png', // Bottom layer photo path
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
            child: signUpPageState.buildTextField(
                'New password', passwordController, 'your password'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
            child: signUpPageState.buildTextField('Confirm new password',
                checkPasswordController, 'confirm password'),
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
                if (passwordController.text == checkPasswordController.text) {
                  changepassword();
                } else {
                  // Handle password mismatch
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        title: Text('Error'),
                        content: Text('Passwords do not match.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              primary:
                                  Color(0xFF146001), // Set the text color here
                            ),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                // Handle button press
              },
              child: Text(
                'RESET PASSWORD',
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
  void changepassword() async {

  String password = passwordController.text;

  // Create a FormData object to include text and image data
   Map<String, dynamic> FormData ={
    'email' : widget.email,
    'password': password,
  };

  try {
    var response = await dio.post('http://localhost:3099/changepassword', data: FormData);
    
    // Handle the API response
    if (response.statusCode == 200) {
      // API call was successful
      print('API Response: ${response.statusCode} ${response.data}');
      print(FormData);

      // Navigate back to the login page
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
    } else {
      // API call was not successful
      print('API Response: ${response.statusCode} ${response.data}');
      
      // Handle other responses or show an error message
      // handleApiError(context, response);
    }
  } catch (error) {
    // Handle errors
    print('Error: $error');
  }
}
}
