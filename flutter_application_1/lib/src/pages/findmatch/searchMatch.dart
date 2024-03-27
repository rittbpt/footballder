import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class FindMatchInfo {
  final String matchName;
  final String stadiumName;
  final String date;
  final String time;
  final int matchId;
  final String photolink;

  FindMatchInfo({
    required this.matchName,
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.matchId,
    required this.photolink,
  });

  factory FindMatchInfo.fromJson(Map<String, dynamic> json) {
    return FindMatchInfo(
      matchName: json['matchName'] ?? '',
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photolink: json['photo'] ?? '',
      matchId: json['MatchId'] != null
          ? int.tryParse(json['MatchId'].toString()) ?? 0
          : 0,
    );
  }
}

class SearchMatchPage extends StatefulWidget {
  @override
  SearchMatchPageState createState() => SearchMatchPageState();
}

int userId = globalApiResponse!.userData!['id'];

class SearchMatchPageState extends State<SearchMatchPage> {
  TextEditingController SearchController = TextEditingController();

  late Future<List<FindMatchInfo>> futureFindMatchList;

  @override
  void initState() {
    super.initState();
    futureFindMatchList = fetchData();
  }

  void refreshData() {
    setState(() {
      futureFindMatchList = fetchData();
    });
  }

  Future<List<FindMatchInfo>> fetchData() async {
    List<FindMatchInfo> FindMatchList = [];

    try {
      final response =
          await getApi('http://localhost:3099/getallmatch/7');

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        // print(responseData);
        // print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> requestJsonList = responseData['data'];

          // Create StadiumInfo objects from the fetched data
          FindMatchList = requestJsonList
              .map((json) => FindMatchInfo.fromJson(json))
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
    // print(FindMatchList);

    return FindMatchList;
  }

  // List<Match> matches = [
  //   Match(
  //     name: 'ปล่อยใจจอยๆ',
  //     stadiumName: 'สนามแกรนด์ ซอคเกอร์โปร',
  //     date: 'March 25, 2024',
  //     imageUrl: 'assets/Images/homescreen1.png',
  //   ),
  //   Match(
  //     name: 'Match 2',
  //     stadiumName: 'Stadium 2',
  //     date: 'April 2, 2024',
  //     imageUrl: 'assets/Images/homescreen1.png',
  //   ),
  //   // Add more matches as needed
  // ];

  @override
  Widget build(BuildContext context) {
    ChatSelectionPageState chatSelectionPageState = ChatSelectionPageState();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            width: 375,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Find Match',
                  style: TextStyle(
                    color: Color(0xFF146001),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                chatSelectionPageState.buildSearchBox(SearchController, 0),
                SizedBox(height: 20),
                FutureBuilder<List<FindMatchInfo>>(
                  future: futureFindMatchList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while waiting for data
                      return Container(
                        alignment: Alignment
                            .center, // Center the CircularProgressIndicator
                        margin:
                            EdgeInsets.only(top: 20), // Add margin from the top
                        child: CircularProgressIndicator(
                          color: Color(0xFF146001),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Handle error state
                      return Text('Error fetching data');
                    } else {
                      // Data has been successfully fetched, display it
                      List<FindMatchInfo> findMatchList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: findMatchList.length,
                        itemBuilder: (context, index) {
                          FindMatchInfo findMatch = findMatchList[index];
                          return buildMatchCard(
                              context, findMatch);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


Widget buildMatchCard(
    BuildContext context, FindMatchInfo findMatch) {
  final TextEditingController _positionController = TextEditingController();
  void request(String position) async {
    int MatchId = findMatch.matchId;
    String Position = position;
    int userid = userId;
    String apiUrl = 'http://localhost:3099/insertrequest';

    Map<String, dynamic> requestBody = {
      'MatchId': MatchId,
      'Position': Position,
      'userId': userid
    };

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        print('match ${MatchId}');
        print('match ${Position}');
        print('match ${userid}');

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

  return Card(
    margin: EdgeInsets.symmetric(vertical: 10),
    color: Color.fromARGB(255, 243, 243, 243),
    elevation: 0, // Remove card elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(20.0), // Adjust the radius as needed
          child: Image.network(
            findMatch.photolink,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                findMatch.matchName,
                style: TextStyle(
                  color: Color(0xFF146001),
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Adjust horizontal padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.stadium_outlined,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${findMatch.stadiumName}',
                          style: TextStyle(
                              // Adjust style as needed
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: const Color.fromARGB(255, 63, 44, 44),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${findMatch.date}',
                          style: TextStyle(
                              // Adjust style as needed
                              ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${findMatch.time}',
                          style: TextStyle(
                              // Adjust style as needed
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF146001),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          title: Text('Position'),
                          content: TextField(
                            controller: _positionController,
                            decoration: InputDecoration(
                              hintText: 'Enter your position',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                String position = _positionController.text;
                                request(position);
                                Navigator.of(context).pop();
                                refreshData();
                                // Add logic to save friend's name;
                              },
                              child: Text('Request'),
                              style: TextButton.styleFrom(
                                primary: Color(
                                    0xFF146001), // Set the text color here
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    // Handle button press
                  },
                  child: Text(
                    'Request to join!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DM Sans-Bold',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.84,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}