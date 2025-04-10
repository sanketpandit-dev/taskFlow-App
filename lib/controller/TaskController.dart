import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/TaskModel.dart';

class TaskController {
  final String baseUrl = "http://taskmgmtapi.alphonsol.com";

  Future<bool> addTask(TaskModel task, String jwtToken) async {
    try {
      print("Sending token: Bearer $jwtToken");
      final response = await http.post(
        Uri.parse('$baseUrl/api/task/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',  // ✅ Add "Bearer " prefix
        },
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add task: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }
}