// controllers/leave_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/LeaveRequestModel.dart';

class LeaveController {
  // Method to get leave requests (using the original endpoint)
  Future<List<LeaveRequest>> getLeaveRequests({
    required String jwtToken,
    required int userId,
  }) async {
    print('=== getLeaveRequests ===');
    print('Request URL: http://taskmgmtapi.alphonsol.com/api/leave/requests?userId=$userId');
    print('Headers: Bearer $jwtToken');

    final response = await http.get(
      Uri.parse('http://taskmgmtapi.alphonsol.com/api/leave/requests?userId=$userId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LeaveRequest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leave requests');
    }
  }


  Future<List<LeaveRequest>> getLeaveStatus({
    required int userId,
  }) async {
    try {
      final url = Uri.parse("http://taskmgmtapi.alphonsol.com/api/leave/LeaveStatus/$userId");

      print('=== getLeaveStatus ===');
      print('Request URL: $url');

      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final dataList = responseData['data'] as List;
          print('Data items count: ${dataList.length}');
          print('First item: ${dataList.isNotEmpty ? json.encode(dataList.first) : "none"}');

          return dataList.map((item) {
            print('Processing item: ${json.encode(item)}');
            try {
              return LeaveRequest.fromJson(item);
            } catch (e) {
              print('Error parsing item: $e');
              rethrow;
            }
          }).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch leave status');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in getLeaveStatus: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch leave status: $e');
    }
  }

  // Method to submit leave request (with logging)
  Future<int> submitLeaveRequest({
    required String jwtToken,
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    // Create request body
    final requestBody = {
      'UserID': userId,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      'Reason': reason,
      'CreatedBy': userId,
    };

    print('=== submitLeaveRequest ===');
    print('Request URL: http://taskmgmtapi.alphonsol.com/api/leave/request');
    print('Headers: Bearer $jwtToken');
    print('Request body: ${json.encode(requestBody)}');

    final response = await http.post(
      Uri.parse('http://taskmgmtapi.alphonsol.com/api/leave/request'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['leaveID'];
    } else {
      throw Exception('Failed to submit leave request: ${response.body}');
    }
  }
}