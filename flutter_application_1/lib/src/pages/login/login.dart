import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/buttonStyle.dart';
import 'package:flutter_application_1/src/pages/home/Home.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter/services.dart';

void lineSDKInit() async {
  await LineSDK.instance.setup("2001910409").then((_) {
    print("LineSDK is Prepared");
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;
  bool _obscureText = true;

  @override
  void initState() {
    lineSDKInit();
    super.initState();
    _usernameController.text = "admin";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Container(
            margin: EdgeInsets.only(top: 60),
            width: 70,
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset('assets/Images/footballderlogo.png'),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    "FOOTBALLDER",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF146001),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: const Text(
                          "username",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF146001),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color(0xff1D1617).withOpacity(0.09),
                            blurRadius: 40,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(bottom: 8),
                        height: 50,
                        child: Container(
                          child: TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: const Text(
                          "password",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF146001),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: const Color(0xff1D1617).withOpacity(0.09),
                            blurRadius: 40,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          obscureText: _obscureText,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                checkColor: Colors.black,
                                fillColor: MaterialStateProperty.all(
                                    Color(0xffD2F2C7)),
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF146001),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Forget password ?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF146001),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Adjust as needed
                          children: [
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleClicklogin,
                                style: styleButton,
                                child: const Text(
                                  "SIGN IN",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: handleLineSignIn,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xffD2F2C7)),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Add your local Image widget
                                    Image.asset(
                                      'assets/Images/linelogo.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Add some spacing between the image and text
                                    Text(
                                      "SIGN IN WITH LINE",
                                      style:
                                          TextStyle(color: Color(0xFF146001)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                            onTap: () {
                              // Navigate to the sign-up page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()), // Replace SignUpPage with the actual page you want to navigate to
                              );
                            },
                              child: const Text(
                                "You don't have an account yet?  Sign up",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF146001),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                           ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleClicklogin() {
    print("login test (${_usernameController.text})");
    print("login test (${_passwordController.text})");
  }

  void handleLineSignIn() async {
    try {
      final result = await LineSDK.instance.login();

      var displayname = result.userProfile?.displayName;
      var userId = result.userProfile?.userId;
      var imageUrl = result.userProfile?.pictureUrl;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
              userId: userId, displayname: displayname, imageUrl: imageUrl),
        ),
      );
    } on PlatformException catch (e) {
      print("Error during Line sign-in");
      print(e);
    }
  }
}
