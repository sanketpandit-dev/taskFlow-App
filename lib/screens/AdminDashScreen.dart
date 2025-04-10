import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'AddTaskScreen.dart';
import 'AdminLeaveRequestsScreen.dart';
import 'LoginScreen.dart';
import 'ManageUserScreen.dart';
import 'ProjectListScreen.dart';
import 'UserListScreen.dart';
import 'ViewTaskScreen.dart';


class Admindashscreen extends StatelessWidget {
  const Admindashscreen({Key? key}) : super(key: key);
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _performLogout(context);
    }
  }

  Future<void> _performLogout(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    const storage = FlutterSecureStorage();
    final storedToken = await storage.read(key: "auth_token");

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {

      final response = await http.post(
        Uri.parse('http://taskmgmtapi.alphonsol.com/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      ).timeout(const Duration(seconds: 10));

      // Close loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Clear all stored data
        await storage.deleteAll();


        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Logout failed: ${response.body}')),
        );
      }
    } catch (e) {

      Navigator.of(context).pop();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Manage Tasks',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.person, color: Colors.black),
                      ),
                      onPressed: () => _showLogoutConfirmation(context),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Column(
                  children: [

                    Container(
                      height: 100,
                      child: DashboardCard(
                        icon: Icons.visibility,
                        iconBackgroundColor: Colors.white.withOpacity(0.4),
                        title: 'View User',
                        subtitle: 'View daily task of users',
                        value: 'View',
                        backgroundColor: const Color(0xFFE0D6FF),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Userlistscreen()));
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      height:100 ,
                      child: DashboardCard(
                        icon: Icons.add,
                        iconBackgroundColor: Colors.white.withOpacity(0.4),
                        title: 'Manage Project',
                        subtitle: 'Manage Project lists',
                        value: '',
                        backgroundColor: const Color(0xFFD6E6FF),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProjectListScreen()));
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    Container(
                      height:100 ,
                      child: DashboardCard(
                        icon: Icons.manage_accounts_outlined,
                        iconBackgroundColor: Colors.white.withOpacity(0.4),
                        title: 'Manage User',
                        subtitle: 'Manage All User',
                        value: '',
                        backgroundColor: const Color(0xFFD6E6FF),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserListScreen()));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 100,
                      child: DashboardCard(
                        icon: Icons.beach_access,
                        iconBackgroundColor: Colors.white.withOpacity(0.4),
                        title: 'Leave Request',
                        subtitle: 'View all leave requests',
                        value: '',
                        backgroundColor: const Color(0xFFFFD6E6),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLeaveRequestsScreen()));

                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final String value;
  final Color backgroundColor;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.black),
            ),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}