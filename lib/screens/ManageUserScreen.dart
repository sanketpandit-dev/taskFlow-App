import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Static List of Users (Later, fetch dynamically from API)
  List<Map<String, String>> users = [
    {"name": "John Doe", "email": "john@example.com"},
    {"name": "Jane Smith", "email": "jane@example.com"},
    {"name": "Michael Brown", "email": "michael@example.com"},
    {"name": "Emma Wilson", "email": "emma@example.com"},
    {"name": "David Johnson", "email": "david@example.com"},
  ];

  // Function to Delete User
  void deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("User List",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color(0xFF7F3DFF),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: users.isEmpty
            ? Center(
          child: Text(
            "No users available",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF7F3DFF),
                  child: Text(
                    users[index]['name']![0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  users[index]['name']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(users[index]['email']!),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
