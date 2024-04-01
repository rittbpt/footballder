// api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiResponse {
  final dynamic data;
  final String? token;
  final Map<String, dynamic>? userData;

  ApiResponse({required this.data, this.token, this.userData});
}

String? globalToken;
ApiResponse? globalApiResponse;

void resetGlobalVariables() {
  globalToken = null;
  globalApiResponse = null;
}

void resetUserData() {
  globalApiResponse = null;
}

Future<ApiResponse> postloginApi(String apiUrl, Map<String, dynamic> requestBody) async {
  var dio = Dio();
  try {
    var response = await dio.post(apiUrl, data: requestBody);
    resetGlobalVariables();
    
    // Extract token from response headers or body
    globalToken = response.data['token'];

    // Extract user data from response data
    Map<String, dynamic>? extractedUserData = response.data['data'];

    globalApiResponse = ApiResponse(data: response.data, token: globalToken, userData: extractedUserData);

    // Return ApiResponse with data and token
    return ApiResponse(data: response.data, token: globalToken, userData: extractedUserData);
  } catch (error) {
    throw error;
  }
}

Future<ApiResponse> postEditPofileApi(String apiUrl, Map<String, dynamic> requestBody) async {
  var dio = Dio();
  try {
    var response = await dio.post(apiUrl, data: requestBody);
    resetUserData();
    

    // Extract user data from response data
    Map<String, dynamic>? extractedUserData = response.data['data'];

    globalApiResponse = ApiResponse(data: response.data, token: globalToken, userData: extractedUserData);

    // Return ApiResponse with data and token
    return ApiResponse(data: response.data, token: globalToken, userData: extractedUserData);
  } catch (error) {
    throw error;
  }
}

Future<Response<dynamic>> postApi(String apiUrl, Map<String, dynamic> requestBody) async {
  var dio = Dio();
  
  try {

    if (globalToken == null) {
      throw Exception('Token not available');
    }
    // Create headers map
    var headers = <String, dynamic>{
      'token': globalToken,
    };

    // Create Options object
    Options options = Options(headers: headers);

    // Make API call with options
    var response = await dio.post(apiUrl, data: requestBody, options: options);
    
    return response;
  } catch (error) {
    throw error;
  }
}

Future<Response<dynamic>> getApi(String apiUrl,) async {
  var dio = Dio();
  
  try {

    if (globalToken == null) {
      throw Exception('Token not available');
    }
    // Create headers map
    var headers = <String, dynamic>{
      'token': globalToken,
    };

    // Create Options object
    Options options = Options(headers: headers);

    // Make API call with options
    var response = await dio.get(apiUrl, options: options);
    
    return response;
  } catch (error) {
    throw error;
  }
}

Future<Response<dynamic>> getOtpApi(String apiUrl, Map<String, dynamic> requestBody) async {
  var dio = Dio();
  
  try {

    // Make API call with options
    var response = await dio.post(apiUrl, data: requestBody);
    
    return response;
  } catch (error) {
    throw error;
  }
}


void handleApiError(BuildContext context, DioError error) {
  print('API Error: ${error.response?.statusCode} ${error.response?.data}');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'DM Sans-Bold',
          ),
        ),
        content: Text(
          'An error occurred. Please try again.',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'DM Sans-Regular',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.blue,
                fontFamily: 'DM Sans-Bold',
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      );
    },
  );
}
