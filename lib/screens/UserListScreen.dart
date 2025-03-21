import 'package:flutter/material.dart';

import 'ViewTaskAdmin.dart';

class User {
  final String name;
  final String projectName;
  final String avatarUrl;

  User({required this.name, required this.projectName, this.avatarUrl = ''});
}
class Userlistscreen extends StatelessWidget {
  const Userlistscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<User> users = [
      User(name: 'Emma Wilson', projectName: 'Website Redesign'),
      User(name: 'James Rodriguez', projectName: 'Mobile App Development'),
      User(name: 'Sophia Chen', projectName: 'UI/UX Design'),
      User(name: 'Michael Brown', projectName: 'Database Migration'),
      User(name: 'Olivia Garcia', projectName: 'Content Marketing'),
      User(name: 'William Lee', projectName: 'API Integration'),
      User(name: 'Ava Martinez', projectName: 'QA Testing'),
      User(name: 'Ethan Thompson', projectName: 'SEO Optimization'),
      User(name: 'Isabella Wright', projectName: 'Branding Project'),
      User(name: 'Daniel Clark', projectName: 'Data Analysis'),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme:IconThemeData(color: Colors.white),
        title: const Text("Users List",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color (0xFF7F3DFF),
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
              child: Container(
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
                    return UserListItem(user: users[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

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
                _getInitials(user.name),
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
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color (0xFF7F3DFF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.projectName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0),
            ),
            child:  Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios,size: 14,color: Color(0xFF999999),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Viewtaskadmin()));
                },
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
    int hash = user.name.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[hash];
  }
}


