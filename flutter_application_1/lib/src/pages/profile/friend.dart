import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/profile/friendBox.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class FriendInfo {
  final String firstName;
  final String photo;
  final String friendId;
  final int chatId;

  FriendInfo({
    required this.firstName,
    required this.photo,
    required this.friendId,
    required this.chatId,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    return FriendInfo(
      firstName: json['firstName'] ?? '', // Update with the correct key
      photo: json['photo'] ?? '', // Update with the correct key
      friendId: json['id'] ?? '',
      chatId: json['chatId'] != null ? int.tryParse(json['chatId'].toString()) ?? 0 : 0,
    );
  }
}

class FriendPage extends StatefulWidget {
  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  TextEditingController SearchController = TextEditingController();
  List<FriendInfo> allChats = []; // List of all chats
  List<FriendInfo> filteredChats = [];
  Future<List<FriendInfo>>? futureFriendList;


  @override
  void initState() {
    super.initState();
    fetchFriendList();
  }

  void refreshData() {
    setState(() {
      fetchFriendList();
    });
  }

  void fetchFriendList() async {
    try {
      List<FriendInfo> friendList = await fetchData();
      setState(() {
        allChats = friendList;
        filteredChats = List.from(allChats);
        futureFriendList = Future.value(friendList); // Initialize filteredChats with allChats
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<List<FriendInfo>> fetchData() async {
    List<FriendInfo> FriendList = [];
    String userId = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/friends/${userId}';

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
          FriendList = requestJsonList
              .map((json) => FriendInfo.fromJson(json))
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
    print(FriendList);

    return FriendList;
  }




  void filterChats(String query) {
    setState(() {
      // filteredChats.clear();
      filteredChats = allChats.where((friend) => friend.firstName.toLowerCase().contains(query.toLowerCase())).toList();
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
                          hintText: 'Enter your friend ID',
                        ),
                        onChanged: (value) {
                        newFriendName = value;
                      },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Add logic to save friend's name
                            // addFriend(newFriendName); 
                            _onAddFriendPressed(newFriendName);
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
          FutureBuilder<List<FriendInfo>>(
            future: futureFriendList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || futureFriendList == null) {
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
                    FriendInfo friend = filteredChats[index];
                    print(friend.friendId);
                    return FriendBox(
                      name: friend.firstName,
                      avatarUrl: friend.photo,
                      friendId: friend.friendId,
                      chatId: friend.chatId,
                    );
                    
                  },
                  
                );
              }
            },
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
  void _onAddFriendPressed(String newFriendName) async {
  try {
    // Add friend and wait for completion
    await addFriend(newFriendName);

    // Once addFriend is completed, refresh data and navigate back
    refreshData();
    Navigator.of(context).pop();
  } catch (error) {
    // Handle errors if necessary
    print('Error adding friend: $error');
  }
}

  addFriend(String newFriendName) async {
    String friendId = newFriendName;
    String userid = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/addfriend';

    Map<String, dynamic> requestBody = {
        'friendId': friendId,
      'userId': userid
      };

    // Create a FormData object to include text and image data

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        // refreshData();

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
    // refreshData();
  }
}
