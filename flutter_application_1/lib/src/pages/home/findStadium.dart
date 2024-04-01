import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/chat/chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';

class StadiumInfo {
  final String name;
  final double lat;
  final double lng;
  final List<String> photoLinks;
  final double rating;
  final String phoneNumber;
  final String vicinity;

  StadiumInfo({
    required this.name,
    required this.lat,
    required this.lng,
    required this.photoLinks,
    required this.rating,
    required this.phoneNumber,
    required this.vicinity,
  });

  factory StadiumInfo.fromJson(Map<String, dynamic> json) {
    return StadiumInfo(
      name: json['name'] ?? '',
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString()) ?? 0.0
          : 0.0,
      lng: json['lng'] != null
          ? double.tryParse(json['lng'].toString()) ?? 0.0
          : 0.0,
      photoLinks: (json['photolinks'] != null && json['photolinks'] is List)
          ? List<String>.from(json['photolinks'])
          : [],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 0.0
          : 0.0,
      phoneNumber: json['phoneNumber'] ?? '',
      vicinity: json['vicinity'] ?? '',
    );
  }
}

class FindStadiumPage extends StatefulWidget {
  @override
  FindStadiumPageState createState() => FindStadiumPageState();
}

class FindStadiumPageState extends State<FindStadiumPage> {
  TextEditingController SearchController = TextEditingController();
  // List<StadiumInfo> stadiumList = [];
  List<StadiumInfo> allStadiums = []; // List of all chats
  List<StadiumInfo> filteredStadiums = [];
  Future<List<StadiumInfo>>? futureStadiumList;

  @override
  void initState() {
    super.initState();
    fetchStadiumList();
  }

  void fetchStadiumList() async {
    try {
      List<StadiumInfo> chatList = await fetchData();
      setState(() {
        allStadiums = chatList;
        filteredStadiums = List.from(allStadiums);
        futureStadiumList = Future.value(chatList); // Initialize filteredChats with allChats
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  Future<List<StadiumInfo>> fetchData() async {
    List<StadiumInfo> stadiumList = [];

    try {
      final response = await getApi('http://localhost:3099/getlocation');

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> locations = responseData['data']['locations'];

          // Create StadiumInfo objects from the fetched data
          stadiumList = locations
              .map((location) => StadiumInfo.fromJson(location))
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
    print(stadiumList);

    return stadiumList;
  }

  void filterStadiums(String query) {
    setState(() {
      // filteredChats.clear();
      filteredStadiums = allStadiums.where((stadium) => stadium.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatSelectionPageState chatSelectionPageState = ChatSelectionPageState();

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
                  'Find Stadium',
                  style: TextStyle(
                    color: Color(0xFF146001),
                    fontSize: 24,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.bold,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                chatSelectionPageState.buildSearchBox(SearchController, 0,filterStadiums),
                SizedBox(height: 20),
                FutureBuilder<List<StadiumInfo>>(
                  future: futureStadiumList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting|| futureStadiumList == null) {
                      // Display a loading indicator while waiting for data
                      return Container(
                        alignment: Alignment.center, // Center the CircularProgressIndicator
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
                      // List<StadiumInfo> stadiumList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredStadiums.length,
                        itemBuilder: (context, index) {
                          StadiumInfo stadium = filteredStadiums[index];
                          return buildStadiumCard(stadium);
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

  Widget buildStadiumCard(StadiumInfo stadium) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stadium.photoLinks.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120, // Fixed width for each photo
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: stadium.photoLinks.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(stadium.photoLinks[index]),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage(
                                    'assets/images/homescreen1.png'), // Provide path to default image asset
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stadium.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF146001),
                      ),
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        Text(
                          '${stadium.rating}',
                          style: TextStyle(
                            color: Color.fromRGBO(160, 167, 177, 1),
                          ),
                        ),
                        SizedBox(width: 5),
                        buildRatingStars(stadium.rating),
                      ],
                    ),
                    SizedBox(height: 1),
                    Container(
                      width: 250, // Custom width based on your requirements
                      child: Text(
                        stadium.vicinity,
                        style: TextStyle(
                          color: Color.fromRGBO(160, 167, 177, 1),
                        ), // Optional: Align text within the container
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Tel: ${stadium.phoneNumber}',
                      style: TextStyle(
                        color: Color.fromRGBO(160, 167, 177, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 35, // Adjust the width to make the circle smaller
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF146001),
              ),
              child: IconButton(
                iconSize: 20,
                icon: Icon(Icons.location_on,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  _launchMaps(stadium.lat, stadium.lng);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRatingStars(double rating) {
    Color starColor =
        Color(0xFF146001); // Example logic for color based on rating
    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < rating.floor(); i++) {
      stars.add(Icon(Icons.star, color: starColor));
    }

    // Add half star if needed
    if (rating % 1 != 0) {
      stars.add(Icon(Icons.star_half, color: starColor));
    }

    // Add remaining empty stars
    int emptyStars = 5 - rating.ceil();
    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: starColor));
    }

    return Row(children: stars);
  }

// Function to launch Google Maps with specified latitude and longitude
  Future<void> _launchMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
