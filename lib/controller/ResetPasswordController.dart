import '../services/ResetPasswordService.dart';

class ResetPasswordController {
  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  Future<void> resetPassword(
      String email,
      String otp,
      String newPassword,
      String confirmPassword,
      Function(bool, String) onComplete
      ) async {
    if (email.isEmpty || otp.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      onComplete(false, 'All fields are required');
      return;
    }

    if (newPassword != confirmPassword) {
      onComplete(false, 'Passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      onComplete(false, 'Password must be at least 6 characters');
      return;
    }

    try {
      final response = await _resetPasswordService.verifyOtpAndResetPassword(
          email,
          otp,
          newPassword
      );
      onComplete(response.success, response.message);
    } catch (e) {
      onComplete(false, 'Error: ${e.toString()}');
    }
  }
}