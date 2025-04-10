import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    print('Parsed JSON: $json');

    return ApiResponse(
      success: json.containsKey('Success') ? json['Success'] : false,
      message: json.containsKey('Message') ? json['Message'] : 'Unknown response',
    );
  }
}

class ResetPasswordService {
  final String baseUrl = 'http://taskmgmtapi.alphonsol.com';

  Future<ApiResponse> verifyOtpAndResetPassword(
      String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/api/reset-password/verify');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Email': email,
          'OTP': otp,
          'NewPassword': newPassword,
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse(
          success: true,
          message: jsonResponse['Message'] ?? 'Password reset successfully',
        );
      }
      else {
        final errorJson = jsonDecode(response.body);
        return ApiResponse(
            success: false,
            message: errorJson.containsKey('Message') ? errorJson['Message'] : 'Failed to reset password'
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }
}
