import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/roleModels.dart';

class RoleController {
  Future<RoleResponse> fetchRoles() async {
    final response = await http.get(Uri.parse('http://taskmgmtapi.alphonsol.com/api/roles'));

    if (response.statusCode == 200) {
      return RoleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load roles');
    }
  }
}