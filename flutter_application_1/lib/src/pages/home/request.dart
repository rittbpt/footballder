import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/checkin.dart';


class RequestInfo {
  final String firstName;
  final int age;
  final String position;
  final String photoLink;
  final String stadium;
  final String day;
  final String time;
  // final DateTime day;

  RequestInfo({
    required this.firstName,
    required this.age,
    required this.position,
    required this.photoLink,
    required this.stadium,
    required this.day,
    required this.time,
  });

  factory RequestInfo.fromJson(Map<String, dynamic> json) {
    return RequestInfo(
      firstName: json['firstName'] ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0,
      position: json['position'] ?? '',
      photoLink: json['photoLink'] ?? '',
      stadium: json['namelocation'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
    );
  }
}

class Request extends StatefulWidget {
  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<Request> {
  late Future<List<RequestInfo>> futureRequestList;
  int userId = globalApiResponse!.userData!['id'];
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
    // fetchData().then((data) {
    //   setState(() {
    //     stadiumList = data;
    //   });
    // });
  }

  void refreshData() {
    setState(() {
      futureRequestList = fetchData();
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
          List<dynamic> requestJsonList = responseData['data'];

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
                  'Request to join',
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
                          return _buildMatchBox(stadium, acceptMatch, index);
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
  Widget _buildMatchBox(
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
                image: AssetImage(request.photoLink),
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
              // SizedBox(height: 5),
              Text(
                '${request.stadium}',
                style: TextStyle(
                  fontSize: 12,
                  // color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Row(children: [
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
                        accept();
                        refreshData();
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
                        decline();
                        refreshData();
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

  void accept() async {
    int requestID = 1;
    bool status = true;
    String apiUrl = 'http://localhost:3099/updateRqstatus';

    Map<String, dynamic> requestBody = {
      'requestID': requestID,
      'status': status
    };

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');

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

  void decline() async {
    int requestID = 1;
    bool status = false;
    String apiUrl = 'http://localhost:3099/updateRqstatus';

    Map<String, dynamic> requestBody = {
      'requestID': requestID,
      'status': status
    };

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');

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
