import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/chat/chat.dart';

class MemberBox extends StatelessWidget {
  final String name;
  final String avatarUrl;
  // final String friendId;
  // final int chatId;

  const MemberBox({
    Key? key,
    required this.name,
    required this.avatarUrl,
    // required this.friendId,
    // required this.chatId,
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
          ],
        ),
      ),
    );
  }

}
