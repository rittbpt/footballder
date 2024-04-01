import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_application_1/src/pages/home/dateTime.dart';
import 'package:dio/dio.dart';


class LocationData {
  final String name;
  final String placeId;

  LocationData({required this.name, required this.placeId});
}

class Post extends StatefulWidget {
  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<Post> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  String? selectedLocation;
  String? selectedAmount;
  DateTime? selectedDateTime;
  String? placeId;
  List<String> databaseData = []; // List of location names
  Map<String, String> locationIdMap =
      {}; // Map to store name to placeId mapping
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await getApi('http://localhost:3099/getlocation');

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('data')) {
          List<dynamic> locations = responseData['data']['locations'];
          databaseData = locations
              .map<String>((location) => location['name'] as String)
              .toList();
          locationIdMap = Map.fromIterable(locations,
              key: (location) => location['name'] as String,
              value: (location) => location['place_id'] as String);

          int nameCount = databaseData.length;
          print('Number of names: $nameCount');
          setState(() {
            databaseData = databaseData;
          });
        } else {
          throw Exception('Data format is incorrect');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    SignUpPageState signUpPageState = SignUpPageState();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the desired height
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
          // Other properties and widgets of the AppBar...
        ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            width: 375,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.post_add,
                      color: Color(0xFF146001),
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Add Post',
                      style: TextStyle(
                        color: Color(0xFF146001),
                        fontSize: 24,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.bold,
                        height: 0.06,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                signUpPageState.buildTextField(
                    'Title', TitleController, 'Enter your title'),
                customDropdown(
                  'Location',
                  databaseData,
                  selectedLocation,
                  (value) {
                    setState(() {
                      selectedLocation = value;
                      // Map selected location name to its placeId
                      placeId = locationIdMap[value!];
                      // Use placeId as needed
                      print('Selected Location: $value, Place ID: $placeId');
                    });
                  },
                ),
                DateTimeDropdown(
                  onChanged: (DateTime? dateTime) {
                    setState(() {
                      selectedDateTime = dateTime;
                    });
                  },
                ),
                customDropdown(
                  'Amount',
                  generateNumberList(1, 50),
                  selectedAmount,
                  (value) {
                    setState(() {
                      selectedAmount = value;
                    });
                  },
                ),
                buildTallTextField(
                    'Description (optional)', DescriptionController),
                buildPostButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDropdown(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF146001),
            fontFamily: 'DM Sans-Bold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            // Hide default underline
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildTallTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.09),
            blurRadius: 0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      margin:
          EdgeInsets.only(bottom: 12), // Increased margin for more separation
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF146001),
              fontFamily: 'DM Sans-Bold',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8), // Increased height for more space
          Container(
            height: 135, // Set three times the desired height
            child: TextField(
              controller: controller,
              maxLines: 3, // Allowing multiple lines of text
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 8), // Increased height for more space
        ],
      ),
    );
  }

  Widget buildPostButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Perform sign-up action and check if passwords match
          if (TitleController.text.isNotEmpty &&
              selectedAmount != null &&
              selectedLocation != null &&
              selectedDateTime != null) {
            post();
          } else {
            // Handle password mismatch
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  title: Text('Error'),
                  content: Text('enter every line'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                      style: TextButton.styleFrom(
                        primary: Color(0xFF146001), // Set the text color here
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF146001),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          'POST',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'DM Sans-Bold',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.84,
          ),
        ),
      ),
    );
  }

  void post() async {
    String title = TitleController.text;
    String description = DescriptionController.text;
    String location_Id = placeId ?? '';
    DateTime? selectedDate = selectedDateTime;
    String amount = selectedAmount ?? '';
    String userid = globalApiResponse!.userData!['id'];
    String apiUrl = 'http://localhost:3099/insertmatch';

    Map<String, dynamic> requestBody = {
        'matchName': title,
      'Description': description,
      'locationId': location_Id,
      'selectDatetime':
          selectedDate?.toString() ?? '', // Convert DateTime to String
      'amount': amount,
      'statusMatch' : 'wait' ,
      "userCreate" : userid
      };

    // Create a FormData object to include text and image data

    print(selectedDate.toString());
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

  List<String> generateNumberList(int start, int end) {
    List<String> numbers = [];
    for (int i = start; i <= end; i++) {
      numbers.add('   $i');
    }
    return numbers;
  }
}
