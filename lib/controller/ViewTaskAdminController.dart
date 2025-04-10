// controllers/task_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/ViewTaskAdmin.dart';

class Viewtaskadmincontroller {
  Future<ViewTaskAdmin> fetchTasks(String userId, DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final response = await http.post(
      Uri.parse('http://taskmgmtapi.alphonsol.com/api/tasks/view'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'UserID': userId,
        'SelectedDate': formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return ViewTaskAdmin.fromJson(data[0]);
      }
      return ViewTaskAdmin.empty(selectedDate);
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}