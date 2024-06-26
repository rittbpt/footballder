import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/home/matched.dart';
import 'package:flutter_application_1/src/pages/profile/setting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/profile/editProfile.dart';
import 'package:flutter_application_1/src/pages/profile/setting.dart';
import 'package:flutter_application_1/src/pages/profile/friend.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/login/login.dart';

class ProfilePage extends StatefulWidget {
  // final String? userId;
  // final String? displayName;
  // final String? imageUrl;

  // const ProfilePage({Key? key, this.userId, this.displayName, this.imageUrl})
  //     : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// String firstName = globalApiResponse!.userData!['firstName'];
// String photo = globalApiResponse!.userData!['photo'];
// int age = globalApiResponse!.userData!['age'];

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String firstName = globalApiResponse!.userData!['firstName'];
    String photo = globalApiResponse!.userData!['photo'];
    String userid = globalApiResponse!.userData!['id'];
    int age = globalApiResponse!.userData!['age'];
    // print("age ${age}");
    return Scaffold(
      body: Stack(
        children: [
          // Bottom layer photo
          Image.asset(
            'assets/Images/profilepage.png', // Bottom layer photo path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Top layer photo
          Positioned(
            top: 220, // Adjust top position
            left: 90, // Adjust left position
            width: 200, // Adjust width
            height: 200,
            child: ClipOval(
              // Adjust height
              child: Image.network(
                photo, // Top layer photo path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(
                  0,
                  MediaQuery.of(context).size.height *
                      0.10), // Set right to null
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${firstName}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF146001),
                    ),
                  ),
                  if (age != 0)
                    Text(
                      ",${age}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF146001),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 190,
            left: 60,
            width: 65,
            height: 65,
            child: CircularButton(
              icon: Icons.settings,
              iconColor: Color(0xFF146001),
              text: 'SETTING',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
          ),
          Positioned(
            bottom: 160,
            left: 65,
            child: Text(
              "SETTING",
              style: TextStyle(fontSize: 12),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 168,
            width: 75,
            height: 75,
            child: CircularButton(
              icon: Icons.edit,
              iconColor: Color(0xFF146001),
              text: 'EDIT PROFILE ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
          ),
          Positioned(
            bottom: 140,
            left: 168,
            child: Text(
              "EDIT PROFILE",
              style: TextStyle(fontSize: 12),
            ),
          ),
          Positioned(
            bottom: 190,
            left: 280,
            width: 65,
            height: 65,
            child: CircularButton(
              icon: Icons.group,
              iconColor: Color(0xFF146001),
              text: 'FRIEND',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendPage()),
                );
              },
            ),
          ),
          Positioned(
            bottom: 160,
            left: 290,
            child: Text(
              "FRIENDS",
              style: TextStyle(fontSize: 12),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(
                  0,
                  MediaQuery.of(context).size.height *
                      0.35), // Set right to null
              child: Text(
                "Chat ID:${userid}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 203, 203, 203),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const CircularButton(
      {Key? key,
      required this.icon,
      this.iconColor,
      required this.text,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // Adjust as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          primary: Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // Hide shadow to avoid overlap
          elevation: 0, // Hide elevation to avoid overlap
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
