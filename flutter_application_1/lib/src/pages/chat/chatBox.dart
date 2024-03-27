import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatScreen.dart';

class FriendChatBox extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isUnread;

  const FriendChatBox({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isUnread = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to chat screen when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(name: name), // Replace ChatScreen with your actual chat screen widget
          ),
        );
      },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(
                    color: isUnread ? Colors.black : Colors.grey, // Change text color based on whether it's unread or not
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              isUnread
                  ? CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.blue,
                    )
                  : SizedBox(),
             ],
           ),
         ],
       ),
      ),
    );
  }
}
