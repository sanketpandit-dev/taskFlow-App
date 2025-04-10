import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ProjectModel.dart';


class ProjectController {
  Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('http://taskmgmtapi.alphonsol.com/api/project'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
