class Task {
  final int taskId;
  final String taskName;
  final String status;
  final String? projectName;
  final String? description;
  final DateTime startDate;

  Task({
    required this.taskId,
    required this.taskName,
    required this.status,
    this.projectName,
    this.description,
    required this.startDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskID'] ?? 0,
      taskName: json['taskName'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      projectName: json['projectName'],
      description: json['taskDescription'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
    );
  }
}
