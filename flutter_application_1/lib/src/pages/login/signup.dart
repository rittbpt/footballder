import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Create an Account',
          style: TextStyle(
            color: Color(0xFF146001),
            fontFamily: 'DM Sans-Bold',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          width: 375,
          height: 812,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Email', emailController),
              buildTextField('Phone Number', phoneNumberController),
              buildTextField('Firstname', firstNameController),
              buildTextField('Lastname', lastNameController),
              buildPasswordTextField('Password', passwordController),
              buildPasswordTextField(
                  'Confirm Password', confirmPasswordController),
              SizedBox(height: 20),
              buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.09),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF146001),
              fontFamily: 'DM Sans-Bold',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordTextField(
      String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.09),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF146001),
              fontFamily: 'DM Sans-Bold',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Perform sign-up action and check if passwords match
          if (passwordController.text == confirmPasswordController.text) {
            signUp();
          } else {
            // Handle password mismatch
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Passwords do not match.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF146001),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          'SIGN UP',
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

  void signUp() async {
    String email = emailController.text;
    String phoneNumber = phoneNumberController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String password = passwordController.text;

    String apiUrl = 'http://localhost:3099/Login';

    Map<String, dynamic> requestBody = {
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName' : lastName,
      'password': password,
    };

    try {
      var response = await http.post(Uri.parse(apiUrl), body: requestBody);
      // Handle the API response
      print('API Response: ${response.statusCode} ${response.body}');
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }
}
