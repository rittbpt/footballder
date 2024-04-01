import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/home/matched.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/chat/chat.dart';

class GetChatInfo {
  final String photo;
  final String firstName;
  final String message;
  final String date;
  final String time;

  GetChatInfo({
    required this.photo,
    required this.firstName,
    required this.message,
    required this.date,
    required this.time,
  });

  factory GetChatInfo.fromJson(Map<String, dynamic> json) {
    return GetChatInfo(
      photo: json['photo'] ?? '', // Update with the correct key
      firstName: json['firstName'] ?? '', // Update with the correct key
      message: json['data'] ?? '', // Update with the correct key
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  final int chatId;

  const ChatScreen({Key? key, required this.name, required this.chatId})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = []; // Using a map for message and time
  late IO.Socket socket;
  late Future<List<GetChatInfo>> futureGetChatList;
  String checkFirstName = globalApiResponse!.userData!['firstName'];
  String userId = globalApiResponse!.userData!['id'];

  void refreshData() {
    setState(() {
      futureGetChatList = fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    futureGetChatList = fetchData();
    socket = IO.io('http://localhost:3099', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket');
    });
    socket.on('chat message ${userId}', (data) {
      // Handle incoming messages
      setState(() {
        _messages.add({'message': data['message'], 'time': data['time']});
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  Future<List<GetChatInfo>> fetchData() async {
    List<GetChatInfo> GetChatList = [];
    String apiUrl = 'http://localhost:3099/chat/getchat/${widget.chatId}';
    print("this is chatid ${widget.chatId} ");

    try {
      final response = await getApi(apiUrl);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> requestJsonList = responseData['data'];

          // Create StadiumInfo objects from the fetched data
          GetChatList = requestJsonList
              .map((json) => GetChatInfo.fromJson(json))
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
    print(GetChatList);

    return GetChatList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(widget.name),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: FutureBuilder<List<GetChatInfo>>(
        future: futureGetChatList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for data
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF146001),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            // Data has been successfully fetched, display it
            List<GetChatInfo> matchList = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20), // Add space from the top
                        Column(
                          children: matchList.map((match) {
                            return _buildMessageBubble(match);
                          }).toList(),
                        ),
                        SizedBox(height: 20), // Add space at the bottom
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void addMessage(String message) async {

    String userid = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/chat/save';

    Map<String, dynamic> requestBody = {
      'data': message,
      'userId': userid,
      'chatId' : widget.chatId,
      'Type' : 1
    };

    // Create a FormData object to include text and image data

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');

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

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Get the current time when sending a message
      String currentTime = '${DateTime.now().hour}:${DateTime.now().minute}';
      socket.emit('chat message', {'message': message, 'time': currentTime});
      GetChatInfo sentMessage = GetChatInfo(
        photo: '', // Update with appropriate photo
        firstName: checkFirstName,
        message: message,
        date: '', // Update with appropriate date
        time: currentTime,
      );
      addMessage(message);
      setState(() {
        _messages.add({'message': message, 'time': currentTime});
        futureGetChatList.then((chatList) {
          chatList.add(sentMessage);
          _messageController.clear();
        });
      });
    }
  }

  Widget _buildMessageBubble(GetChatInfo chat) {
    bool isSentByCurrentUser;
    if (checkFirstName == chat.firstName) {
      isSentByCurrentUser = true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  chat.time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  chat.message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ],
      );
    } else {
      isSentByCurrentUser = false;
      return Column(
        // Wrap Row with Column
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(chat.photo),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat.firstName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      chat.message,
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              Container(
                                child: Text(
                                  chat.time,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
  }
}
