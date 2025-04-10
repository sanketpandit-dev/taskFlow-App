import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/TaskModel.dart';


class TaskRepository {
  final String _baseUrl = 'http://taskmgmtapi.alphonsol.com/api/task/add';

  Future<bool> addTask(TaskModel task) async {
    try {
      // Retrieve JWT token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');
      final userType = prefs.getInt('userType');

      if (token == null || userId == null || userType == null) {
        throw Exception('Authentication information is missing');
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final responseBody = json.decode(response.body);
        return responseBody['message'] == 'Task added successfully';
      } else {
        // Parse error message from API
        final errorMessage = json.decode(response.body)['message'] ?? 'Task addition failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }
}