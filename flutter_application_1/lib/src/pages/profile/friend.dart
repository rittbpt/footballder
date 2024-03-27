import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/profile/friendBox.dart';

class FriendPage extends StatefulWidget {
  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  TextEditingController SearchController = TextEditingController();
  List<FriendBox> allChats = []; // List of all chats
  List<FriendBox> filteredChats = [];

  @override
  void initState() {
    super.initState();
    // Initialize your chat data
    allChats = [
      FriendBox(
        name: 'Johny',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
      FriendBox(
        name: 'John',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
      FriendBox(
        name: 'max',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
      FriendBox(
        name: 'pp',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
      FriendBox(
        name: 'steve',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
      // Add more chat data here
    ];
    // Initially, set filteredChats to allChats
    filteredChats.addAll(allChats);
  }

  void addFriend(String friendName) {
    setState(() {
      allChats.add(
        FriendBox(
          name: friendName,
          avatarUrl: 'https://via.placeholder.com/150',
        ),
      );
      filteredChats.add(
        FriendBox(
          name: friendName,
          avatarUrl: 'https://via.placeholder.com/150',
        ),
      );
    });
  }

  void filterChats(String query) {
    setState(() {
      filteredChats.clear();
      if (query.isNotEmpty) {
        filteredChats.addAll(allChats.where(
            (chat) => chat.name.toLowerCase().contains(query.toLowerCase())));
      } else {
        filteredChats.addAll(allChats);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        title: Center(
          child: Text(
            'Friends',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newFriendName = '';
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      title: Text('Add friend'),
                      content: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter friend name',
                        ),
                        onChanged: (value) {
                        newFriendName = value;
                      },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Add logic to save friend's name
                            addFriend(newFriendName); 
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                          style: TextButton.styleFrom(
                        primary: Color(0xFF146001), // Set the text color here
                      ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                  child: Container(
                    child: Icon(
                      Icons.person_add,
                      color: Color(0xFF146001),
                      size: 30,
                    ),
                  ),
              ),
            ),
          ],
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
