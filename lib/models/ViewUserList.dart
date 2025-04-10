class ViewUserList {
  final String fullName;
  final String designation;
  final String userID;

  ViewUserList({
    required this.fullName,
    required this.designation,
    required this.userID,
  });

  factory ViewUserList.fromJson(Map<String, dynamic> json) {
    return ViewUserList(
      fullName: json['fullName'],
      designation: json['designation'],
      userID: json['userID'],
    );
  }
}