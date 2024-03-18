import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.all(10),
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
                    fontWeight: FontWeight.bold,
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
    );
  }
}
