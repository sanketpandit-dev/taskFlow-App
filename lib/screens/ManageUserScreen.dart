import 'package:flutter/material.dart';

import '../models/ManageUserList.dart';
import '../services/ManageUserService.dart';


class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  List<ManageUserModel> users = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() {
        errorMessage = '';
        isRefreshing = true;
      });

      final fetchedUsers = await _userService.getAllUsers();

      setState(() {
        users = fetchedUsers;
        isLoading = false;
        isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = _getErrorMessage(e);
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Failed host lookup')) {
      return 'No internet connection';
    } else if (error.toString().contains('404')) {
      return 'Server not found';
    }
    return 'Failed to load users. Please try again.';
  }

  Future<void> _deactivateUser(int userId, String userName) async {
    try {
      final success = await _userService.deactivateUser(userId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$userName deactivated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchUsers(); // Refresh the list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to deactivate: ${_getErrorMessage(e)}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeactivateDialog(int userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deactivation"),
        content: Text("Are you sure you want to deactivate $userName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deactivateUser(userId, userName);
            },
            child: Text(
              "Deactivate",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(BuildContext context, int index) {
    final user = users[index];
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
            user.initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: Icon(Icons.delete_outlined, color: Colors.red),
          onPressed: () => _showDeactivateDialog(user.userID, user.fullName),
          tooltip: "Deactivate User",
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && users.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty && users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUsers,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7F3DFF),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchUsers,
      color: Color(0xFF7F3DFF),
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: _buildUserItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("User List", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF7F3DFF),
        actions: [
          if (isRefreshing)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchUsers,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}