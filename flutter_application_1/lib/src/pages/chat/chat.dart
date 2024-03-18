import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatBox.dart';

class ChatSelectionPage extends StatefulWidget {
  @override
  _ChatSelectionPageState createState() => _ChatSelectionPageState();
}

class _ChatSelectionPageState extends State<ChatSelectionPage> {

  TextEditingController SearchController = TextEditingController();

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
      body: ListView(
        children: [
          _buildSearchBox(SearchController),
          SizedBox(height: 10),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
          FriendChatBox(
            name: 'John Doe',
            message: 'Hello there!',
            time: '10:30 AM',
            avatarUrl: 'https://via.placeholder.com/150', // Sample URL, replace with actual image URL
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.message),
      ),
    );
  }

  Widget _buildSearchBox(TextEditingController controller) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
            height: 45, // Set the desired height
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search", // Hint text
                hintStyle: TextStyle(
                  color: Color(0xFFA0A7B1), // Text color before typing
                ),
                contentPadding: EdgeInsets.only(left: 5),
              ),
            ),
          ),
    );
  }

  Widget _buildListSection(List<String> items) {
    return Column(
      children: items
          .map(
            (item) => ListTile(
              leading: CircleAvatar(
                child: Text(item[0]), // Display the first letter of the name
              ),
              title: Text(item),
              onTap: () {
                _navigateToChatPage(context, item);
              },
            ),
          )
          .toList(),
    );
  }

  void _navigateToChatPage(BuildContext context, String recipient) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(recipient: recipient)),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String recipient;

  ChatPage({required this.recipient});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipient),
      ),
      body: Center(
        child: Text('Chat with ${widget.recipient}'),
      ),
    );
  }
}


