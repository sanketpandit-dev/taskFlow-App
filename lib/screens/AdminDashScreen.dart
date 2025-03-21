import 'package:flutter/material.dart';
import 'AddTaskScreen.dart';
import 'ManageUserScreen.dart';
import 'ProjectListScreen.dart';
import 'UserListScreen.dart';
import 'ViewTaskScreen.dart';


class Admindashscreen extends StatelessWidget {
  const Admindashscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
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
                  Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.person, color: Colors.black),
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
                      value: '5',
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
                      icon: Icons.add,
                      iconBackgroundColor: Colors.white.withOpacity(0.4),
                      title: 'Manage User',
                      subtitle: 'Manage All User',
                      value: '10',
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
                      subtitle: 'Submit leave application',
                      value: '2d',
                      backgroundColor: const Color(0xFFFFD6E6),
                      onTap: () {

                      },
                    ),
                  ),
                ],
              ),
            ],
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