class TaskModel {
  final int? projectID;
  final String taskName;
  final String taskDescription;
  final DateTime startDate;
  final DateTime endDate;
  final int statusId;
  final int? createdBy;

  TaskModel({
    this.projectID,
    required this.taskName,
    required this.taskDescription,
    required this.startDate,
    required this.endDate,
    required this.statusId,
    this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProjectID': projectID,
      'TaskName': taskName,
      'TaskDescription': taskDescription,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      'Status': statusId,
      'CreatedBy': createdBy,
    };
  }
}