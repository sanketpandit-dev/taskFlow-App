import 'package:flutter/material.dart';
import '../services/OtpService.dart';


class OtpController {
  final OtpService _otpService = OtpService();


  Future<void> generateOtp(String email, Function(bool, String) onComplete) async {
    if (email.isEmpty) {
      onComplete(false, 'Please enter your email');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      onComplete(false, 'Please enter a valid email address');
      return;
    }

    try {
      final response = await _otpService.generateOtp(email);
      onComplete(response.success, response.message);
    } catch (e) {
      onComplete(false, 'Error: ${e.toString()}');
    }
  }
}