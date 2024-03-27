import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendBox extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const FriendBox({
    Key? key,
    required this.name,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // Navigate to chat screen when tapped
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (context) => ChatScreen(name: name), // Replace ChatScreen with your actual chat screen widget
      //     ),
      //   );
      // },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 243, 243, 243), // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(10), // Border radius
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80, // Adjusted width for a smaller button
              height: 30, // Adjusted height for a smaller button
              child: ElevatedButton(
                onPressed: () {
                  // Handle button click
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF146001),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 0), // Adjusted padding
                  side: BorderSide(
                      width: 0,
                      color: Color(0xFF146001)), // Adjusted border width
                ),
                child: Text(
                  'Chat',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
