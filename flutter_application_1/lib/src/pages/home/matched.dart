import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/home/checkIn.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class MatchInfo {
  final String stadiumName;
  final String date;
  final String time;
  final String photoLink;

  MatchInfo({
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.photoLink,
  });

  factory MatchInfo.fromJson(Map<String, dynamic> json) {
    return MatchInfo(
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photoLink: json['photo'] ?? '',
    );
  }
}

class Match extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

int userId = globalApiResponse!.userData!['id'];

class MatchPageState extends State<Match> {
  late Future<List<MatchInfo>> futureMatchList;

  @override
  void initState() {
    super.initState();
    futureMatchList = fetchData();
  }

  void refreshData() {
    setState(() {
      futureMatchList = fetchData();
    });
  }

  Future<List<MatchInfo>> fetchData() async {
    List<MatchInfo> MatchList = [];
    String apiUrl = 'http://localhost:3099/getmatchdone/7';

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
          MatchList =
              requestJsonList.map((json) => MatchInfo.fromJson(json)).toList();
        } else {
          throw Exception('Data format is incorrect');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
    print(MatchList);

    return MatchList;
  }
  // Example data from the database
  // List<Map<String, dynamic>> matchesData = [
  //   {
  //     'photo': 'assets/Images/linelogo.png',
  //     'text': 'Sample Text 1',
  //     'time': '12:30 PM',
  //   },
  //   {
  //     'photo': 'URL_TO_PHOTO_2',
  //     'text': 'Sample Text 2',
  //     'time': '2:45 PM',
  //   },
  //   // Add more data as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          automaticallyImplyLeading: true,
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
                  'Match',
                  style: TextStyle(
                    color: Color(0xFF146001),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                FutureBuilder<List<MatchInfo>>(
                  future: futureMatchList,
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
                      List<MatchInfo> matchList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: matchList.length,
                        itemBuilder: (context, index) {
                          MatchInfo match = matchList[index];
                          return _buildMatchBox(match);
                        },
                      );
                    }
                  },
                ),
                // Use ListView.builder to dynamically generate boxes based on data
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: matchesData.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return _buildMatchBox(matchesData[index]);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each match box
  Widget _buildMatchBox(MatchInfo match) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFFDFE2DB),
            const Color.fromARGB(255, 255, 255, 255)
          ], // Change colors as needed
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Left side with square photo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(match.photoLink),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          // Center column with text and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              Container(
                width: 200, // Set your desired width here
                child: Text(
                  match.stadiumName,
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip, // Clip overflowing text
                ),
              ),
              Text(
                match.date,
                style: TextStyle(
                  fontSize: 16,
                  // color: Colors.grey,
                ),
              ),
              Text(
                '16:00',
                style: TextStyle(
                  fontSize: 16,
                  // color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              // Row for multiple buttons
              Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 80, // Adjusted width for a smaller button
                    height: 30, // Adjusted height for a smaller button
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button click
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF46A02F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 0), // Adjusted padding
                        side: BorderSide(
                            width: 0,
                            color: Color(0xFF46A02F)), // Adjusted border width
                      ),
                      child: Text(
                        'Chat',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 80, // Adjusted width for a smaller button
                    height: 30, // Adjusted height for a smaller button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage()),
                              );
                        // Handle button click
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF46A02F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8), // Adjusted padding
                        side: BorderSide(
                            width: 0,
                            color: Color(0xFF46A02F)), // Adjusted border width
                      ),
                      child: Text(
                        'Check in',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Add more buttons as needed
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
