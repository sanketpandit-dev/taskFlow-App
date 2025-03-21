import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

      // Debugging: Print response details
      print("Response Status: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Ensure response is JSON before parsing
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          return RegistrationResponse.fromJson(jsonDecode(response.body));
        } else {
          print("Error: Received non-JSON response");
          return RegistrationResponse(
            success: false,
            message: 'Invalid response format. Expected JSON but received something else.',
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
    } catch (e, stackTrace) {
      print("Exception: $e");
      print("StackTrace: $stackTrace");
      return RegistrationResponse(
        success: false,
        message: 'Registration failed: $e',
      );
    }
  }
}
