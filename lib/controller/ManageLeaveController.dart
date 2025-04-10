import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ManageLeaveModel.dart';

class LeaveApiService {
  final String baseUrl = "http://taskmgmtapi.alphonsol.com/api/admin/leave/manage";

  Future<List<ManageLeaveRequest>> fetchLeaveRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/view'));

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Parsed Data: $data");
      return data.map((e) => ManageLeaveRequest.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load leave requests");
    }
  }


  Future<void> updateLeaveStatus(int leaveID, String status, int adminID) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'leaveID': leaveID,
        'status': status,
        'adminID': adminID,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update leave status");
    }
  }
}
