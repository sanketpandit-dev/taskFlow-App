import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/ViewTaskModel.dart';


class Viewtaskcontroller {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Task>> getTasksByDate(DateTime date) async {
    try {
      final userId = await _storage.read(key: "userId");
      final token = await _storage.read(key: "auth_token");

      if (userId == null || token == null) {
        throw Exception("User not authenticated");
      }


      final requestBody = {
        'UserID': int.parse(userId),
        'SelectedDate': DateFormat('yyyy-MM-dd').format(date),
      };


      print("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse("http://taskmgmtapi.alphonsol.com/api/tasks/view"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Print the raw response (for debugging)
      print("Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as List;

        // Debug: Print the first task (if available)
        if (responseData.isNotEmpty) {
          print("First Task Data: ${responseData[0]}");
        }

        return responseData.map((task) => Task.fromJson(task)).toList();
      } else {
        throw Exception("Failed to load tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Task fetch error: $e");
      rethrow;
    }
  }
}