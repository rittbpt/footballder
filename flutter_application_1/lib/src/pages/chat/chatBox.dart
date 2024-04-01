import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatScreen.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';



class FriendChatBox extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int isUnread;
  final int chatId;
  final VoidCallback refreshCallback;

  const FriendChatBox({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.isUnread,
    required this.chatId,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("chat jgggffjfjf ${chatId}");
    return GestureDetector(
      onTap: () {
        // Navigate to chat screen when tapped
        readchat();
        // refreshCallback();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(name: name,chatId: chatId), // Replace ChatScreen with your actual chat screen widget
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
                    fontWeight: isUnread == 1 ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(
                    color: isUnread == 1 ? Colors.black : Colors.grey, // Change text color based on whether it's unread or not
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
              isUnread == 1
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

  void readchat() async {
    // String friendid = friendId;
    String userid = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/chat/readchat';

    Map<String, dynamic> requestBody = {
        'chatId': chatId,
      'userId': userid
      };

    // Create a FormData object to include text and image data

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        refreshCallback();

        // Navigate back to the login page
        // Navigator.pop(context);
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
