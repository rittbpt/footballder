import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/login/otp.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_application_1/src/pages/login/forgetPW.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailController = TextEditingController();
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
            'assets/Images/forgetpw.png', // Bottom layer photo path
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
            child: signUpPageState.buildTextField(
                'Email', emailController, 'yourEmail@gmail.com'),
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
                if (emailController.text.isNotEmpty) {
                  getotp();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        title: Text('Error'),
                        content: Text('Enter your email.'),
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

  void getotp() async {
    String email = emailController.text;

    Map<String, dynamic> requestBody = {'email': email};

    try {
      final response =
          await getOtpApi('http://localhost:3099/sendotp', requestBody);
      print('API Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        // Parse the response data
        print('API Response: ${response.statusCode} ${response.data}');
        String getotp = response.data['otp'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage(getotp,email)),
        );
      } else if (response.statusCode == 400){
        print('API Response: ${response.statusCode} ${response.data}');
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        title: Text('Error'),
                        content: Text('Wrong email.'),
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
        // throw Exception('Failed to fetch data');
      }
      else {
        print('API Response: ${response.statusCode} ${response.data}');
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        title: Text('Error'),
                        content: Text('Wrong email.'),
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
      print('Error: ${error}');
    }
  }
}
