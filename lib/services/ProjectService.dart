import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Project {
  final int? projectID;
  final String projectName;
  final int? createdBy;

  Project({this.projectID, required this.projectName, this.createdBy});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectID: json['projectID'],
      projectName: json['projectName'] ?? 'Unnamed Project', // Handle null case
      createdBy: json['createdBy'],
    );
  }

}

class ProjectService {
  final String baseUrl = 'http://taskmgmtapi.alphonsol.com/api';

  // Get all projects
  Future<List<Project>> getProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Project'));

      print("API Response: ${response.body}"); // Debugging: Check API response

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);

        if (decodedData is List) {
          return decodedData.map((json) => Project.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



  // Add a new project
  Future<String> addProject(String projectName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Project'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ProjectName': projectName,
          'CreatedBy': 1,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to add project: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Deactivate a project
  Future<String> deactivateProject(int projectId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Project/Deactivate/$projectId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        throw Exception('Failed to deactivate project: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}