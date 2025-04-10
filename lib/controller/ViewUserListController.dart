// controllers/user_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ViewUserList.dart';


class UserController {
  Future<List<ViewUserList>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://taskmgmtapi.alphonsol.com/api/users'),
        // headers: {
        //   'Authorization': 'Bearer ${await SecureStorage.getToken()}',
        // },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((userJson) => ViewUserList.fromJson(userJson))
              .toList();
        }
      }
      throw Exception('Failed to load users');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}