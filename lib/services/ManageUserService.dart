import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ManageUserList.dart';

class UserService {
  static const String _baseUrl = 'http://taskmgmtapi.alphonsol.com/api/users';
  static const String _manageEndpoint = '/manage';

  // Headers for API requests
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static void _handleError(dynamic error, StackTrace stackTrace) {
    print('API Error: $error');
    print('Stack Trace: $stackTrace');
    throw Exception('Failed to complete request: $error');
  }


  Future<List<ManageUserModel>> getAllUsers() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_manageEndpoint'),
        headers: _headers,
        body: json.encode({'Action': 'GetAllUsers'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((user) => ManageUserModel.fromJson(user)).toList();
      } else {
        throw Exception(
            'Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      rethrow;
    }
  }

  // Deactivate a user
  Future<bool> deactivateUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_manageEndpoint'),
        headers: _headers,
        body: json.encode({
          'Action': 'Deactivate',
          'UserID': userId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Failed to deactivate user. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      rethrow;
    }
  }
}