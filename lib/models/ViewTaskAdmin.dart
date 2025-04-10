class ViewTaskAdmin {
  final String taskName;
  final String taskDescription;
  final DateTime startDate;
  final String status;
  final String projectName;

  ViewTaskAdmin({
    required this.taskName,
    required this.taskDescription,
    required this.startDate,
    required this.status,
    required this.projectName,
  });

  factory ViewTaskAdmin.fromJson(Map<String, dynamic> json) {
    return ViewTaskAdmin(
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      startDate: DateTime.parse(json['startDate']),
      status: json['status'],
      projectName: json['projectName'],
    );
  }

  // Helper method for no task scenario
  factory ViewTaskAdmin.empty(DateTime date) {
    return ViewTaskAdmin(
      taskName: "No Task",
      taskDescription: "No task available for this date.",
      startDate: date,
      status: "-",
      projectName: "-",
    );
  }
}