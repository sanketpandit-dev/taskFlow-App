class ManageLeaveRequest {
  final int leaveID;
  final int userID;
  final String fullName;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime createdAt;

  ManageLeaveRequest({
    required this.leaveID,
    required this.userID,
    required this.fullName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory ManageLeaveRequest.fromJson(Map<String, dynamic> json) {
    return ManageLeaveRequest(
      leaveID: json['leaveID'] ?? 0,
      userID: json['userID'] ?? 0,
      fullName: json['fullName'] ?? 'N/A',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'] ?? 'No Reason',
      status: json['status'] ?? 'Pending',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
