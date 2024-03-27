import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/home/post.dart';
import 'package:flutter_application_1/src/pages/home/findStadium.dart';
import 'package:flutter_application_1/src/pages/home/matched.dart';
import 'package:flutter_application_1/src/pages/home/request.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class HomePage extends StatefulWidget {
  final String? userId;
  final String? displayName;
  final String? imageUrl;

  const HomePage({Key? key, this.userId, this.displayName, this.imageUrl})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class RecentMatchInfo {
  final String stadiumName;
  final String date;
  final String time;
  final String photoLink;

  RecentMatchInfo({
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.photoLink,
  });

  factory RecentMatchInfo.fromJson(Map<String, dynamic> json) {
    return RecentMatchInfo(
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photoLink: json['photoLink'] ?? '',
    );
  }
}

class _HomePageState extends State<HomePage> {
  String firstName = globalApiResponse!.userData!['firstName'];
  late Future<List<RecentMatchInfo>> futureRecentMatchList;

  @override
  void initState() {
    super.initState();
    futureRecentMatchList = fetchData();
  }

  void refreshData() {
    setState(() {
      futureRecentMatchList = fetchData();
    });
  }

  Future<List<RecentMatchInfo>> fetchData() async {
    List<RecentMatchInfo> RecentMatchList = [];
    String apiUrl = 'http://localhost:3099/getrecent/${userId}';

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
          RecentMatchList = requestJsonList
              .map((json) => RecentMatchInfo.fromJson(json))
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
    print(RecentMatchList);

    return RecentMatchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // Set the desired height
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          // Other properties and widgets of the AppBar...
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 70),
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: 50,
                    height: 51,
                    child: Text(
                      '👋🏻',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          color: Color(0xFF146001),
                          fontSize: 22,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        firstName,
                        style: TextStyle(
                          color: Color(0xFF146001),
                          fontSize: 22,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.06,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(185, 185, 185, 1),
                      ),
                      child: widget.imageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Images/homescreen2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                '50% off',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 0),
                              Text(
                                'สนามแกรนด์ ซอคเกอร์โปร',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Post()),
                                  );
                                  // Handle button click
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(20, 96, 1, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(1, 30),
                                ),
                                child: Text(
                                  'Join Now',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu',
                        style: GoogleFonts.inter(
                          color: Color(0xFF146001),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FindStadiumPage()),
                              );
                            },
                            child: Container(
                              height: 100, // Adjust the height as needed
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/Images/background_menu_0.png'),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Match()),
                              );
                            },
                            child: Container(
                              height: 100, // Adjust the height as needed
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/Images/background_menu_1.png'),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Post()),
                              );
                            },
                            child: Container(
                              height: 100, // Adjust the height as needed
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/Images/background_menu_2.png'),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Request()),
                              );
                            },
                            child: Container(
                              height: 100, // Adjust the height as needed
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/Images/background_menu_3.png'),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Match',
                        style: GoogleFonts.inter(
                          color: Color(0xFF146001),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder<List<RecentMatchInfo>>(
                      future: futureRecentMatchList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while waiting for data
                          return Container(
                            alignment: Alignment
                                .center, // Center the CircularProgressIndicator
                            margin: EdgeInsets.only(
                                top: 20), // Add margin from the top
                            child: CircularProgressIndicator(
                              color: Color(0xFF146001),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // Handle error state
                          return Text('Error fetching data');
                        } else {
                          // Data has been successfully fetched, display it
                          List<RecentMatchInfo> recentMatchList =
                              snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recentMatchList.length,
                            itemBuilder: (context, index) {
                              RecentMatchInfo recentMatch =
                                  recentMatchList[index];
                              return _buildMatchBox(recentMatch);
                            },
                          );
                        }
                      },
                    ),
                    // FutureBuilder<List<MatchInfo>>(
                    //   future: fetchData(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Container(
                    //         alignment: Alignment
                    //             .center, // Center the CircularProgressIndicator
                    //         margin: EdgeInsets.only(
                    //             top: 20), // Add margin from the top
                    //         child: CircularProgressIndicator(
                    //           color: Color(0xFF146001),
                    //         ),
                    //       ); // Display loading indicator while fetching data
                    //     } else if (snapshot.hasError) {
                    //       return Text('Error: ${snapshot.error}');
                    //     } else if (!snapshot.hasData ||
                    //         snapshot.data!.isEmpty) {
                    //       return Text('No recent matches found.');
                    //     } else {
                    //       return Column(
                    //         children: snapshot.data!.map((match) {
                    //           return Container(
                    //             margin: EdgeInsets.symmetric(vertical: 10),
                    //             padding: EdgeInsets.all(10),
                    //             width: double.infinity,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                   color: const Color.fromARGB(
                    //                       255, 255, 255, 255)),
                    //               borderRadius: BorderRadius.circular(10),
                    //               gradient: LinearGradient(
                    //                 colors: [
                    //                   Color(0xFFDFE2DB),
                    //                   const Color.fromARGB(255, 255, 255, 255)
                    //                 ], // Change colors as needed
                    //                 begin: Alignment.topCenter,
                    //                 end: Alignment.bottomCenter,
                    //               ),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text('${match.photoName}'),
                    //                 SizedBox(height: 5),
                    //                 Text('Date: ${match.date}'),
                    //                 SizedBox(height: 5),
                    //                 Text('Time: ${match.time}'),
                    //               ],
                    //             ),
                    //           );
                    //         }).toList(),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchBox(RecentMatchInfo recentMatch) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
        borderRadius: BorderRadius.circular(10),
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
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(recentMatch.photoLink),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),
          // Center column with text and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              Container(
                width: 200, // Set your desired width here
                child: Text(
                  recentMatch.stadiumName,
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip, // Clip overflowing text
                ),
              ),
              Text(
                recentMatch.date,
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
            ],
          ),
        ],
      ),
    );
  }
}
