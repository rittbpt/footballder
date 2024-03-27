
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/src/pages/home/date.dart';


class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  DateTime? selectedDate;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? _selectedImage;

  Dio dio = Dio();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF146001),
            fontFamily: 'DM Sans-Bold',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
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
                SizedBox(height: 20),
                buildImagePicker(),
                buildTextField('Email', emailController, 'yourEmail@gmail.com'),
                buildTextField('Phone Number', phoneNumberController, '0xxxxxxxxx'),
                buildTextField('Firstname', firstNameController, 'firstname'),
                buildTextField('Lastname', lastNameController, 'lastname'),
                DateDropdown(
                  onChanged: (DateTime? dateTime) {
                    setState(() {
                      selectedDate = dateTime;
                    });
                  },
                ),
                buildPasswordTextField('Password', passwordController),
                buildPasswordTextField(
                    'Confirm Password', confirmPasswordController),
                SizedBox(height: 12),
                buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () {
          pickImage();
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: _selectedImage != null
              ? ClipOval(
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 40,
                ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Widget buildTextField(String label, TextEditingController controller, String hintText) {
    return Container(  // Adjust the width as needed
      // height: 154,  
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.09),
          blurRadius: 0,
          spreadRadius: 0.0,
        ),
      ]),
      margin: EdgeInsets.only(bottom: 4),
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
          SizedBox(height: 8),
          Container(
            height: 45, // Set the desired height
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: Color.fromARGB(255, 137, 156, 132)),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

Widget buildNumberTextField(String label, TextEditingController controller) {
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
    margin: EdgeInsets.only(bottom: 4),
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
        SizedBox(height: 8),
        Container(
          height: 45,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    ),
  );
}


  Widget buildPasswordTextField(
      String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.09),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      margin: EdgeInsets.only(bottom: 8),
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
          SizedBox(height: 8),
          Container(
            height: 45,
            child: TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Perform sign-up action and check if passwords match
          if (passwordController.text == confirmPasswordController.text) {
            signUp();
          } else {
            // Handle password mismatch
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  title: Text('Error'),
                  content: Text('Passwords do not match.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: Color(0xFF146001), // Set the text color here
                      ),
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
          'SAVE',
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

  void signUp() async {


  String email = emailController.text;
  String phoneNumber = phoneNumberController.text;
  String firstName = firstNameController.text;
  String lastName = lastNameController.text;
  String password = passwordController.text;
  DateTime? birthday = selectedDate;

  // Create a FormData object to include text and image data
  var formData = FormData.fromMap({
    'email': email,
    'phoneNumber': phoneNumber,
    'firstName': firstName,
    'lastName': lastName,
    'password': password,
    'birthDay': birthday?.toString() ?? '',
    'photo': "1",
  });

  print(MultipartFile.fromFile(_selectedImage!.path));

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

}

