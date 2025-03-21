// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../models/user_registration_model.dart';
//
// class SignUpService {
//
//   static const String _signUpUrl = 'http://taskmgmtapi.alphonsol.com/api/registration';
//
//
//   Future<Map<String, dynamic>> signUp(UserRegistrationModel user) async {
//     try {
//
//       final Map<String, dynamic> requestBody = {
//         'EmployeeID': user.employeeId,
//         'FirstName': user.firstName,
//         'LastName': user.lastName,
//         'MobileNumber': user.mobileNumber,
//         'Email': user.email,
//         'Designation': user.designation,
//         'Password': user.password,
//       };
//
//
//       final http.Response response = await http.post(
//         Uri.parse(_signUpUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//
//
//       if (response.statusCode == 200) {
//         return responseData;
//       } else {
//         throw Exception('Failed to sign up: ${responseData['Message']}');
//       }
//     } catch (e) {
//       throw Exception('Error during sign-up: $e');
//     }
//   }
// }