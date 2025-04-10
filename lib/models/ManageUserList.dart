class ManageUserModel {
  final int userID;
  final String firstName;
  final String lastName;
  final String email;

  ManageUserModel({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
  });


  String get fullName => '$firstName $lastName';


  String get initials {
    if (firstName.isEmpty && lastName.isEmpty) return '?';
    if (firstName.isEmpty) return lastName[0].toUpperCase();
    if (lastName.isEmpty) return firstName[0].toUpperCase();
    return '${firstName[0]}${lastName[0]}'.toUpperCase();
  }

  factory ManageUserModel.fromJson(Map<String, dynamic> json) {
    return ManageUserModel(
      userID: json['userID'] ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? 'No email',
    );
  }
}