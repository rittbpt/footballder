import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/profile/friendBox.dart';
import 'package:flutter_application_1/src/pages/home/memberBox.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class MemberInfo {
  final String firstName;
  final String photo;

  MemberInfo({
    required this.firstName,
    required this.photo,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      firstName: json['firstName'] ?? '', // Update with the correct key
      photo: json['photo'] ?? '', // Update with the correct key
    );
  }
}

class MemberPage extends StatefulWidget {
  final int matchId;

  const MemberPage({Key? key, required this.matchId})
      : super(key: key);
  @override
  MemberPageState createState() => MemberPageState();
}

class MemberPageState extends State<MemberPage> {
  TextEditingController SearchController = TextEditingController();
  List<MemberInfo> allChats = []; // List of all chats
  List<MemberInfo> filteredChats = [];
  Future<List<MemberInfo>>? futureFriendList;


  @override
  void initState() {
    super.initState();
    fetchMemberList();
  }

  void refreshData() {
    setState(() {
      fetchMemberList();
    });
  }

  void fetchMemberList() async {
    try {
      List<MemberInfo> MemberList = await fetchData();
      setState(() {
        allChats = MemberList;
        filteredChats = List.from(allChats);
        futureFriendList = Future.value(MemberList); // Initialize filteredChats with allChats
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<List<MemberInfo>> fetchData() async {
    List<MemberInfo> MemberList = [];
    // String userId = globalApiResponse!.userData!['id'];
    int MatchId = widget.matchId;
    String apiUrl = 'http://localhost:3099/getmatchuserjoin/${MatchId}';

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
          MemberList = requestJsonList
              .map((json) => MemberInfo.fromJson(json))
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
    print(MemberList);

    return MemberList;
  }




  void filterChats(String query) {
    setState(() {
      // filteredChats.clear();
      filteredChats = allChats.where((member) => member.firstName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        centerTitle: true,
        title: 
          Text(
            'member',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: Column(
        children: [
          buildSearchBox(SearchController, 20),
          SizedBox(height: 10),
          FutureBuilder<List<MemberInfo>>(
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
                    MemberInfo friend = filteredChats[index];
                    // print(friend.friendId);
                    return MemberBox(
                      name: friend.firstName,
                      avatarUrl: friend.photo,
                      // friendId: friend.friendId,
                      // chatId: friend.chatId,
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
 
}
