import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['Success'] ?? false,
      message: json['Message'] ?? 'Unknown response',
    );
  }
}

class OtpService {
  final String baseUrl = 'http://taskmgmtapi.alphonsol.com';

  Future<ApiResponse> generateOtp(String email) async {
    final url = Uri.parse('$baseUrl/api/otp/generate');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'Email': email}),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse(
          success: jsonResponse['Success'] ?? true,
          message: jsonResponse['Message'] ?? 'OTP sent successfully',
        );
      } else {
        final errorJson = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          message: errorJson['Message'] ?? 'Failed to generate OTP',
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

}