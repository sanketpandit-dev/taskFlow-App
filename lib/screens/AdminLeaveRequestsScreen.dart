import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLeaveRequestsScreen extends StatefulWidget {
  @override
  _AdminLeaveRequestsScreenState createState() => _AdminLeaveRequestsScreenState();
}

class _AdminLeaveRequestsScreenState extends State<AdminLeaveRequestsScreen> {
  List<dynamic> leaveRequests = [];
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    final response = await http.post(
      Uri.parse('http://taskmgmtapi.alphonsol.com/api/admin/leave/manage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ActionType': 'VIEW'}),
    );
    print("API Response: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        leaveRequests = jsonDecode(response.body);
      });
    } else {
      print("Failed to load leave requests. Status Code: ${response.statusCode}");
    }
  }

  Future<void> updateLeaveStatus(int leaveId, String status) async {
    final response = await http.post(
      Uri.parse('http://taskmgmtapi.alphonsol.com/api/admin/leave/manage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ActionType': 'UPDATE', 'LeaveID': leaveId, 'Status': status, 'AdminID': 1}),
    );
    print("Update Response: ${response.body}");
    fetchLeaveRequests();
  }

  void _showDetailsDialog(dynamic leave) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Leave Request Details"),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Employee: ${leave['fullName']}", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Status: ${leave['status']}", style: TextStyle(
                    color: leave['status'] == 'Approved' ? Colors.green :
                    leave['status'] == 'Rejected' ? Colors.red : Colors.orange,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10),
                Text("From: ${leave['startDate']}"),
                Text("To: ${leave['endDate']}"),
                SizedBox(height: 10),
                Text("Reason:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("${leave['reason']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                updateLeaveStatus(leave['leaveID'], 'Approved');
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Approve', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                updateLeaveStatus(leave['leaveID'], 'Rejected');
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Reject', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Requests'),
        elevation: 0,
      ),
      body: leaveRequests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: leaveRequests.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final leave = leaveRequests[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: leave['status'] == 'Approved'
                  ? Colors.green
                  : leave['status'] == 'Rejected'
                  ? Colors.red
                  : Colors.orange,
              child: Icon(
                leave['status'] == 'Approved'
                    ? Icons.check
                    : leave['status'] == 'Rejected'
                    ? Icons.close
                    : Icons.access_time,
                color: Colors.white,
              ),
            ),
            title: Text(
              "${leave['fullName']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Status: ${leave['status']}"),
            trailing: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _showDetailsDialog(leave),
            ),
          );
        },
      ),
    );
  }
}