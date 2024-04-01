import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chatBox.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/home/matched.dart';

class ChatroomInfo {
  final String chatName;
  final String message;
  final String photo;
  final String time;
  final int readed;
  final int chatId;

  ChatroomInfo({
    required this.chatName,
    required this.message,
    required this.photo,
    required this.readed,
    required this.chatId,
    required this.time,
  });

  factory ChatroomInfo.fromJson(Map<String, dynamic> json) {
    return ChatroomInfo(
      chatName: json['name'] ?? '', // Update with the correct key
      message: json['message'] ?? '', // Update with the correct key
      photo: json['photo'] ?? '', // Update with the correct key
      time: json['time'] ?? '',
      readed: json['readed'] != null
          ? int.tryParse(json['readed'].toString()) ?? 0
          : 0,
      chatId: json['ChatID'] != null
          ? int.tryParse(json['ChatID'].toString()) ?? 0
          : 0,
    );
  }
}

class ChatSelectionPage extends StatefulWidget {
  @override
  ChatSelectionPageState createState() => ChatSelectionPageState();
}

class ChatSelectionPageState extends State<ChatSelectionPage> {
  TextEditingController SearchController = TextEditingController();
  List<ChatroomInfo> allChats = []; // List of all chats
  List<ChatroomInfo> filteredChats = [];
  Future<List<ChatroomInfo>>? futureChatroomList;

  @override
  void initState() {
    super.initState();
    // futureChatroomList = fetchData();
    fetchChatList();
  }

  void refreshData() {
    setState(() {
      fetchChatList();
    });
  }

  void fetchChatList() async {
    try {
      List<ChatroomInfo> chatList = await fetchData();
      setState(() {
        allChats = chatList;
        filteredChats = List.from(allChats);
        futureChatroomList = Future.value(chatList); // Initialize filteredChats with allChats
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<List<ChatroomInfo>> fetchData() async {
    String userid = globalApiResponse!.userData!['id'];
    List<ChatroomInfo> ChatroomList = [];
    String apiUrl = 'http://localhost:3099/chats/${userid}';

    try {
      final response = await getApi(apiUrl);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('chats')) {
          List<dynamic> requestJsonList = responseData['chats'];

          // Create StadiumInfo objects from the fetched data
          ChatroomList = requestJsonList
              .map((json) => ChatroomInfo.fromJson(json))
              .toList();
        } else {
          throw Exception('Data format is incorrect');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
    print(ChatroomList);

    return ChatroomList;
  }


  void updateFilteredChats(List<ChatroomInfo> chatroomList) {
    setState(() {
      // Process the data or apply filtering logic here
      // For example, add all items to filteredChats
      filteredChats.clear();
      filteredChats
          .addAll(allChats); // Assuming allChats is populated elsewhere
    });
  }

  void filterChats(String query) {
    setState(() {
      // filteredChats.clear();
      filteredChats = allChats.where((chat) => chat.chatName.toLowerCase().contains(query.toLowerCase())).toList();
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
          buildSearchBox(SearchController, 20, filterChats),
          SizedBox(height: 10),
          FutureBuilder<List<ChatroomInfo>>(
            future: futureChatroomList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || futureChatroomList == null) {
                // Display a loading indicator while waiting for data
                return Container(
                  alignment:
                      Alignment.center, // Center the CircularProgressIndicator
                  margin: EdgeInsets.only(top: 20), // Add margin from the top
                  child: CircularProgressIndicator(
                    color: Color(0xFF146001),
                  ),
                );
              } else if (snapshot.hasError) {
                // Handle error state
                return Text('Error fetching data');
              } else {
                // Data has been successfully fetched, display it
                // List<ChatroomInfo> matchList = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    ChatroomInfo match = filteredChats[index];
                    return FriendChatBox(
                      name: match.chatName,
                      message: match.message,
                      avatarUrl: match.photo,
                      isUnread: match.readed,
                      chatId: match.chatId,
                      time: match.time,
                      refreshCallback: refreshData, 
                    );
                  },
                  
                );
              }
            },
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: filteredChats.length,
          //     itemBuilder: (context, index) {
          //       return filteredChats[index];
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildSearchBox(TextEditingController controller, double padding, filter) {
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
            onChanged: filter,
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
