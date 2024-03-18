import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Match extends StatefulWidget {
  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<Match> {
  // Example data from the database
  List<Map<String, dynamic>> matchesData = [
    {
      'photo': 'assets/Images/linelogo.png',
      'text': 'Sample Text 1',
      'time': '12:30 PM',
    },
    {
      'photo': 'URL_TO_PHOTO_2',
      'text': 'Sample Text 2',
      'time': '2:45 PM',
    },
    // Add more data as needed
  ];

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
            padding: EdgeInsets.symmetric(horizontal: 30),
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
                // Use ListView.builder to dynamically generate boxes based on data
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: matchesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMatchBox(matchesData[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each match box
  Widget _buildMatchBox(Map<String, dynamic> match) {
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
                                    colors: [Color(0xFFDFE2DB), const Color.fromARGB(255, 255, 255, 255)], // Change colors as needed
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
                image: AssetImage(match['photo']),
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
              Text(
                match['text'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Time: ${match['time']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
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
                        // Handle button click
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF46A02F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0), // Adjusted padding
                        side: BorderSide(width: 0,color: Color(0xFF46A02F)), // Adjusted border width
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
                        // Handle button click
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF46A02F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8), // Adjusted padding
                        side: BorderSide(width: 0,color: Color(0xFF46A02F)), // Adjusted border width
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
