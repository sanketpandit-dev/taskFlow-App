import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_registration_model.dart';

class RegistrationResponse {
  final bool success;
  final String message;

  RegistrationResponse({required this.success, required this.message});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error occurred',
    );
  }
}

class RegistrationController {
  final String baseUrl = 'http://taskmgmtapi.alphonsol.com/api/registration';

  Future<RegistrationResponse> registerUser(UserRegistrationModel user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          bool success = responseData['success'] ?? false;
          String message = responseData['message'] ?? 'No message provided';

          if (success) {
            return RegistrationResponse(success: true, message: message);
          } else {
            print("Registration Failed: $message");
            return RegistrationResponse(success: false, message: message);
          }
        } else {
          print("Error: Unexpected response format");
          return RegistrationResponse(
            success: false,
            message: 'Invalid response format from the server.',
          );
        }
      } else {
        return RegistrationResponse(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } on SocketException {
      print("SocketException: No internet connection.");
      return RegistrationResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
      );
    } on FormatException {
      print("FormatException: Invalid JSON response.");
      return RegistrationResponse(
        success: false,
        message: 'Invalid response format from the server.',
      );
    } catch (e, stackTrace) {
      print("Exception: $e");
      print("StackTrace: $stackTrace");
      return RegistrationResponse(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
