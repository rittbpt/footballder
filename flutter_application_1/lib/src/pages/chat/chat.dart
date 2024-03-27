import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatBox.dart';

class ChatSelectionPage extends StatefulWidget {
  @override
  ChatSelectionPageState createState() => ChatSelectionPageState();
}


class ChatSelectionPageState extends State<ChatSelectionPage> {
  TextEditingController SearchController = TextEditingController();
  List<FriendChatBox> allChats = []; // List of all chats
  List<FriendChatBox> filteredChats = [];

  @override
  void initState() {
    super.initState();
    // Initialize your chat data  
    allChats = [
      FriendChatBox(
        name: 'Joh',
        message: 'Hello there!',
        time: '10:30 AM',
        avatarUrl: 'https://via.placeholder.com/150',
        isUnread: false,
      ),
      FriendChatBox(
        name: 'Dave',
        message: 'Hello there!',
        time: '10:30 AM',
        avatarUrl: 'https://via.placeholder.com/150',
        isUnread: false,
      ),
      FriendChatBox(
        name: 'Steve',
        message: 'Hello there!',
        time: '10:30 AM',
        avatarUrl: 'https://via.placeholder.com/150',
        isUnread: true,
      ),
      FriendChatBox(
        name: 'henry',
        message: 'Hello there!',
        time: '10:30 AM',
        avatarUrl: 'https://via.placeholder.com/150',
        isUnread: false,
      ),
      FriendChatBox(
        name: 'Johny',
        message: 'Hello there!',
        time: '10:30 AM',
        avatarUrl: 'https://via.placeholder.com/150',
        isUnread: false,
      ),
      // Add more chat data here
    ];
    // Initially, set filteredChats to allChats
    filteredChats.addAll(allChats);
  }

  void filterChats(String query) {
    setState(() {
      filteredChats.clear();
      if (query.isNotEmpty) {
        filteredChats.addAll(allChats.where((chat) =>
            chat.name.toLowerCase().contains(query.toLowerCase())));
      } else {
        filteredChats.addAll(allChats);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: Column(
        children: [
          buildSearchBox(SearchController, 20),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                return filteredChats[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBox(TextEditingController controller, double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        height: 45, // Set the desired height
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius:
              BorderRadius.circular(10), // Adjust the radius as needed
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: controller,
            onChanged: filterChats,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: "Search", // Hint text
              hintStyle: TextStyle(
                color: Color(0xFFA0A7B1), // Text color before typing
              ),
            ),
          ),
        ),
      ),
    );
  }
}
