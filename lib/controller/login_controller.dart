import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_model.dart';

class LoginController {
  final dio.Dio _dio = dio.Dio();
  final _storage = FlutterSecureStorage();
  final String _baseUrl = "http://taskmgmtapi.alphonsol.com/api/login";


  static const String IS_LOGGED_IN_KEY = "is_logged_in";

  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      dio.Response response = await _dio.post(
        _baseUrl,
        data: jsonEncode(loginModel.toJson()),
        options: dio.Options(headers: {"Content-Type": "application/json"}),
      );

      print("Login API Response: ${response.data}");

      if (response.statusCode == 200) {
        var data = response.data;
        print("Decoded Response Data: $data");

        if (data.containsKey("token")) {

          await _storage.write(key: "auth_token", value: data["token"]);
          await _storage.write(key: "userId", value: data["userId"].toString());
          await _storage.write(key: "userType", value: data["userType"].toString());
          await _storage.write(key: "email", value: loginModel.email);
          await _storage.write(key: "password", value: loginModel.password);

          await _storage.write(key: IS_LOGGED_IN_KEY, value: "true");

          final storedToken = await _storage.read(key: "auth_token");
          final storedUserId = await _storage.read(key: "userId");
          final storedUserType = await _storage.read(key: "userType");
          final storedEmail = await _storage.read(key: "email");
          final storedPassword = await _storage.read(key: "password");

          print("SAVED TOKEN: $storedToken");
          print("USER ID: $storedUserId");
          print("USER TYPE: $storedUserType");
          print("SAVED EMAIL: $storedEmail");
          print("SAVED PASSWORD: $storedPassword");
          print("USER LOGGED IN STATUS: true");

          return {"success": true, "message": "Login successful"};
        } else {
          print("Token not found in response.");
          return {"success": false, "message": "Token not received"};
        }
      } else {
        print("Invalid credentials. Response: ${response.data}");
        return {"success": false, "message": "Invalid credentials"};
      }
    } on dio.DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 401) {
        print("Invalid credentials: ${e.response?.data}");
        return {"success": false, "message": "Invalid email or password"};
      } else {
        print("Error during login: $e");
        return {"success": false, "message": "An error occurred: ${e.message}"};
      }
    } catch (e) {
      print("Error during login: $e");
      return {"success": false, "message": "An error occurred: $e"};
    }
  }

  Future<void> logout() async {

    await _storage.write(key: IS_LOGGED_IN_KEY, value: "false");

    await _storage.deleteAll();
    print("User logged out successfully.");
  }


  Future<bool> isLoggedIn() async {
    String? loginStatus = await _storage.read(key: IS_LOGGED_IN_KEY);
    String? token = await getUserToken();

    return loginStatus == "true" && token != null;
  }

  Future<String?> getUserToken() async {
    final token = await _storage.read(key: "auth_token");
    print("RETRIEVED TOKEN: $token");
    return token;
  }

  Future<String?> getUserType() async {
    return await _storage.read(key: "userType");
  }

  Future<Map<String, String?>> getStoredCredentials() async {
    String? email = await _storage.read(key: "email");
    String? password = await _storage.read(key: "password");
    return {"email": email, "password": password};
  }
}