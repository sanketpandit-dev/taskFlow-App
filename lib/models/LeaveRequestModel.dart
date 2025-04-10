// models/LeaveRequestModel.dart
class LeaveRequest {
  final int leaveID;
  final int userID;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;

  LeaveRequest({
    required this.leaveID,
    required this.userID,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      leaveID: json['leaveID'] ?? 0,
      userID: json['userID'] ?? 0,
      startDate: json.containsKey('startDate') && json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json.containsKey('endDate') && json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

}