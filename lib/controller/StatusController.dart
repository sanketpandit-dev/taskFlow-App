import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/StatusModel.dart';


class StatusController {
  Future<List<Status>> fetchStatuses() async {
    final response = await http.get(Uri.parse('http://taskmgmtapi.alphonsol.com/api/status'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> statusList = jsonResponse['data'];

      return statusList.map((json) => Status.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statuses');
    }
  }
}
