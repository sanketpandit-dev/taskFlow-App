class Project {
  final int projectID;
  final String projectName;

  Project({required this.projectID, required this.projectName});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectID: json['projectID'],
      projectName: json['projectName'],
    );
  }
}
