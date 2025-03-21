class Role {
  final int lookupID;
  final String lookupName;
  final String lookupType;

  Role({
    required this.lookupID,
    required this.lookupName,
    required this.lookupType,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      lookupID: json['lookupID'],
      lookupName: json['lookupName'],
      lookupType: json['lookupType'],
    );
  }
}

class RoleResponse {
  final bool success;
  final String message;
  final List<Role> data;

  RoleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Role> roles = dataList.map((role) => Role.fromJson(role)).toList();

    return RoleResponse(
      success: json['success'],
      message: json['message'],
      data: roles,
    );
  }
}