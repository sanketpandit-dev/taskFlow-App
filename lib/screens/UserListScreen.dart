// views/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../controller/ViewUserListController.dart';
import '../models/ViewUserList.dart';
import 'ViewTaskAdmin.dart';


class Userlistscreen extends StatefulWidget {
  const Userlistscreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<Userlistscreen> {
  final UserController _userController = UserController();
  late Future<List<ViewUserList>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _userController.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Users List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7F3DFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<ViewUserList>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users found'));
                  }

                  final users = snapshot.data!;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserListItem(
                          user: users[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTaskAdminScreen(
                                  userId: users[index].userID,
                                  userName: users[index].fullName,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final ViewUserList user;
  final VoidCallback onTap;

  const UserListItem({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getRandomColor(),
            ),
            child: Center(
              child: Text(
                _getInitials(user.fullName),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB388FF),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.designation,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            )
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0F0F0),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1) {
        initials += nameParts[1][0];
      }
    }
    return initials.toUpperCase();
  }

  Color _getRandomColor() {
    List<Color> colors = [
      const Color(0xFF83ADFF),
      const Color(0xFFA289D1),
      const Color(0xFFFF9EC6),
    ];
    int hash = user.fullName.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[hash];
  }
}