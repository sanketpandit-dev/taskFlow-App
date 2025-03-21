import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String date;
  final String title;
  final String projectName;
  final String description;
  final String userName;

  Task({
    required this.date,
    required this.title,
    required this.projectName,
    required this.description,
    required this.userName,
  });
}

class Viewtaskadmin extends StatefulWidget {
  const Viewtaskadmin({Key? key}) : super(key: key);

  @override
  State<Viewtaskadmin> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<Viewtaskadmin> {
  DateTime selectedDate = DateTime.now();

  // Simulated task data
  final List<Task> tasks = [
    Task(date: "2025-03-11", title: "Bug Fixing", projectName: "App Development", description: "Fixed login issue", userName: "Sanket Pandit"),
    Task(date: "2025-03-10", title: "UI Update", projectName: "Website Redesign", description: "Updated homepage UI", userName: "James Rodriguez"),
    Task(date: "2025-03-09", title: "Testing", projectName: "QA Testing", description: "Performed unit testing", userName: "Sophia Chen"),
  ];

  Task? currentTask;

  @override
  void initState() {
    super.initState();
    _fetchTaskForDate(selectedDate);
  }

  void _fetchTaskForDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    setState(() {
      currentTask = tasks.firstWhere(
            (task) => task.date == formattedDate,
        orElse: () => Task(
          date: formattedDate,
          title: "No Task",
          projectName: "-",
          description: "No task available for this date.",
          userName: "N/A",
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _fetchTaskForDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color (0xFF7F3DFF),
        title: const Text("User Tasks", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),

        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // gradient: const LinearGradient(
              //   colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              color: Color (0xFF7F3DFF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Name
                Text(
                  currentTask!.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),

                // Date Picker
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.white54),

                // Task Details
                Text(
                  currentTask!.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  currentTask!.projectName,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  currentTask!.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Apply Button
                ElevatedButton(
                  onPressed: () => _fetchTaskForDate(selectedDate),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Apply Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color (0xFF7F3DFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor:Colors.white,
    );
  }
}

