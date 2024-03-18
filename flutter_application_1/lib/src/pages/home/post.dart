import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:flutter_application_1/src/pages/login/signup.dart';
import 'package:flutter_application_1/src/pages/home/dateTime.dart';
import 'package:dio/dio.dart';

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
    List<String> databaseData = ['asdf','adfas'];
    Dio dio = Dio();
    
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await Dio().get('https://rit.com/data');

      if (response.statusCode == 200) {
        List<String> data = List<String>.from(response.data);
        setState(() {
          databaseData = data;
        });
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
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
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
                signUpPageState.buildTextField('Title', TitleController),
                customDropdown(
                  'Location',
                  databaseData,
                  selectedLocation,
                  (value) {
                    setState(() {
                      selectedLocation = value;
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
                  generateNumberList(1,50),
                  selectedAmount,
                  (value) {
                    setState(() {
                      selectedAmount = value;
                    });
                  },
                ),
                buildTallTextField('Description (optional)', DescriptionController),
                buildPostButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


Widget customDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) {
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
        child: DropdownButtonHideUnderline( // Hide default underline
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
    margin: EdgeInsets.only(bottom: 12), // Increased margin for more separation
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
          if (
            TitleController.text.isNotEmpty &&
            selectedAmount != null &&
            selectedLocation != null &&
            selectedDateTime != null ) {
            post();
          } else {
            // Handle password mismatch
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('enter every line'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
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
  String location = selectedLocation ?? '';
  DateTime? selectedDate = selectedDateTime;
  String amount = selectedAmount ?? '';

  // Create a FormData object to include text and image data
  FormData formData = FormData.fromMap({
    'title': title,
    'description': description,
    'location': location,
    'selectedDate': selectedDate?.toString() ?? '', // Convert DateTime to String
    'amount': amount,
    // Add other data fields as needed
  });

  print(selectedDate.toString());

  try {
    var response = await dio.post('http://localhost:3099/Register', data: formData);
    
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