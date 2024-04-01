import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/checkin.dart';

class RequestInfo {
  final String firstName;
  final int age;
  final String position;
  final String matchName;
  final String photoLink;
  final String stadium;
  final String day;
  final String time;
  final int rqId;
  // final DateTime day;

  RequestInfo({
    required this.firstName,
    required this.age,
    required this.position,
    required this.matchName,
    required this.photoLink,
    required this.stadium,
    required this.day,
    required this.time,
    required this.rqId,
  });

  factory RequestInfo.fromJson(Map<String, dynamic> json) {
    return RequestInfo(
      firstName: json['firstName'] ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0,
      position: json['position'] ?? '',
      photoLink: json['photo'] ?? '',
      matchName: json['matchName'] ?? '',
      stadium: json['namelocation'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      rqId:
          json['rqId'] != null ? int.tryParse(json['rqId'].toString()) ?? 0 : 0,
    );
  }
}

class MyRequestInfo {
  final String stadiumName;
  final String date;
  final String time;
  final String photoLink;
  final String matchName;

  MyRequestInfo({
    required this.stadiumName,
    required this.date,
    required this.time,
    required this.photoLink,
    required this.matchName,
  });

  factory MyRequestInfo.fromJson(Map<String, dynamic> json) {
    return MyRequestInfo(
      stadiumName: json['namelocation'] ?? '',
      date: json['day'] ?? '',
      time: json['time'] ?? '',
      photoLink: json['photo'] ?? '',
      matchName: json['matchName'] ?? '',
    );
  }
}

class Request extends StatefulWidget {
  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<Request> {
  late Future<List<RequestInfo>> futureRequestList;
  late Future<List<MyRequestInfo>> futureMyRequestList;
  String userId = globalApiResponse!.userData!['id'];
  List<RequestInfo> stadiumData = [];
  void acceptMatch(int index) {
    setState(() {
      stadiumData.removeAt(index); // Remove the match at the specified index
    });
  }

  @override
  void initState() {
    super.initState();
    futureRequestList = fetchData();
    futureMyRequestList = fetchMyRequestData();
    // fetchData().then((data) {
    //   setState(() {
    //     stadiumList = data;
    //   });
    // });
  }

  void refreshData() {
    setState(() {
      futureRequestList = fetchData();
      futureMyRequestList = fetchMyRequestData();
    });
  }

  // Example data from the database
  // List<Map<String, dynamic>> matchesData = [
  //   {
  //     'photo': 'assets/Images/linelogo.png',
  //     'name': 'SMCKY',
  //     'age': 21,
  //     'position': 'CM',
  //     'stadium' : 'สนามแกรนด์ ซอคเกอร์โปร',
  //     'time': '12:30 PM',
  //   },
  //   {
  //     'photo': 'assets/Images/linelogo.png',
  //     'name': 'MC',
  //     'age': 21,
  //     'position': 'CM',
  //     'stadium' : 'สนามแกรนด์ ซอคเกอร์โปร',
  //     'time': '2:45 PM',
  //   },
  //   // Add more data as needed
  // ];

  Future<List<RequestInfo>> fetchData() async {
    List<RequestInfo> RequestList = [];

    try {
      final response =
          await getApi('http://localhost:3099/getrequestbyId/${userId}');

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> requestJsonList = responseData['data']['request'];

          // Create StadiumInfo objects from the fetched data
          RequestList = requestJsonList
              .map((json) => RequestInfo.fromJson(json))
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
    print(RequestList);

    return RequestList;
  }

  Future<List<MyRequestInfo>> fetchMyRequestData() async {
    List<MyRequestInfo> MyRequestList = [];

    try {
      final response =
          await getApi('http://localhost:3099/getrequestbyId/${userId}');

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> requestJsonList = responseData['data']['myrequest'];

          // Create StadiumInfo objects from the fetched data
          MyRequestList = requestJsonList
              .map((json) => MyRequestInfo.fromJson(json))
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
    print(MyRequestList);

    return MyRequestList;
  }

  // Future<List<MyRequestInfo>> fetchMyRequestData() async {
  //   List<MyRequestInfo> MyRequestList = [];

  //   try {
  //     final response =
  //         await getApi('http://localhost:3099/getrequestbyId/${userId}');

  //     if (response.statusCode == 200) {
  //       // Parse the response data
  //       Map<String, dynamic> responseData = response.data;
  //       print(responseData);
  //       print("responseData");

  //       if (responseData.containsKey('data')) {
  //         List<dynamic> requestJsonList = responseData['data']['request'];

  //         // Create StadiumInfo objects from the fetched data
  //         MyRequestList = requestJsonList
  //             .map((json) => MyRequestInfo.fromJson(json))
  //             .toList();
  //       } else {
  //         throw Exception('Data format is incorrect');
  //       }
  //     } else {
  //       throw Exception('Failed to fetch data');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  //   print(MyRequestList);

  //   return MyRequestList;
  // }

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
                  'Other request to join',
                  style: TextStyle(
                    color: Color(0xFF146001),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                FutureBuilder<List<RequestInfo>>(
                  future: futureRequestList,
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
                      List<RequestInfo> stadiumList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stadiumList.length,
                        itemBuilder: (context, index) {
                          RequestInfo stadium = stadiumList[index];
                          return _buildRequestBox(stadium, acceptMatch, index);
                        },
                      );
                    }
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Your request',
                  style: TextStyle(
                    color: Color(0xFF146001),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                FutureBuilder<List<MyRequestInfo>>(
                  future: futureMyRequestList,
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
                      List<MyRequestInfo> stadiumList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stadiumList.length,
                        itemBuilder: (context, index) {
                          MyRequestInfo stadium = stadiumList[index];
                          return _buildMyRequestBox(stadium);
                        },
                      );
                    }
                  },
                ),
                // Use ListView.builder to dynamically generate boxes based on data
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each match box
  Widget _buildRequestBox(
      RequestInfo request, Function(int) onAccept, int index) {
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: NetworkImage(request.photoLink),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          // Center column with text and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // SizedBox(height: 20),
                  SizedBox(width: 10),
                  Text(
                    '${request.firstName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    ', ${request.age} ,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    request.position,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     SizedBox(width: 10),
              // Text(
              //       '${request.matchName}',
              //       style: TextStyle(
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //         // color: const Color.fromARGB(255, 0, 0, 0),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.stadium_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  // SizedBox(height: 5),
                  Text(
                    '${request.stadium}',
                    style: TextStyle(
                      fontSize: 12,
                      // color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              Row(children: [
                SizedBox(width: 10),
                Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: const Color.fromARGB(255, 63, 44, 44),
                  ),
                  SizedBox(width: 5),
                Text(
                  '${request.day}',
                  style: TextStyle(
                    fontSize: 12,
                    // color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '${request.time}',
                  style: TextStyle(
                    fontSize: 12,
                    // color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              // Row for multiple buttons
              Row(
                children: [
                  SizedBox(width: 15),
                  Container(
                    width: 80, // Adjusted width for a smaller button
                    height: 30, // Adjusted height for a smaller button
                    child: ElevatedButton(
                      onPressed: () {
                        accept(request.rqId);
                        // refreshData();
                        // Handle button click
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
                        'Accept',
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
                        decline(request.rqId);
                        // refreshData();
                        // Handle button click
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(221, 204, 40, 40),
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
                        'Decline',
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

  Widget _buildMyRequestBox(MyRequestInfo match) {
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
              Row(
                children: [
                  Text(
                    match.matchName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xFF146001),
                    ),
                    overflow: TextOverflow.clip, // Clip overflowing text
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.stadium_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  Text(
                    match.stadiumName,
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.clip, // Clip overflowing text
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: const Color.fromARGB(255, 63, 44, 44),
                  ),
                  SizedBox(width: 5),
                  Text(
                    match.date,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: const Color.fromARGB(255, 63, 44, 44),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '16:00',
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Row for multiple buttons
            ],
          ),
        ],
      ),
    );
  }

  void accept(int rqId) async {
    bool status = true;
    String apiUrl = 'http://localhost:3099/updateRqstatus';

    Map<String, dynamic> requestBody = {'requestID': rqId, 'status': status};

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        refreshData();

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

  void decline(int rqId) async {
    bool status = false;
    String apiUrl = 'http://localhost:3099/updateRqstatus';

    Map<String, dynamic> requestBody = {'requestID': rqId, 'status': status};

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        refreshData();

        // Navigate back to the login page
        Navigator.pop(context);
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
}
