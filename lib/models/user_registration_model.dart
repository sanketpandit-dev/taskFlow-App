class UserRegistrationModel {
  final String employeeID;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String designation;
  final String password;

  UserRegistrationModel({
    required this.employeeID,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.designation,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'FirstName': firstName,
      'LastName': lastName,
      'MobileNumber': mobileNumber,
      'Email': email,
      'Designation': designation,
      'Password': password,
    };
  }
}