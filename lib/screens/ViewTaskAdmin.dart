import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/ViewTaskAdminController.dart';
import '../models/ViewTaskAdmin.dart';


class ViewTaskAdminScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ViewTaskAdminScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<ViewTaskAdminScreen> createState() => _ViewTaskAdminScreenState();
}

class _ViewTaskAdminScreenState extends State<ViewTaskAdminScreen> {
  final Viewtaskadmincontroller _Viewtaskadmincontroller = Viewtaskadmincontroller();
  DateTime selectedDate = DateTime.now();
  ViewTaskAdmin? currentTask;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    try {
      final task = await _Viewtaskadmincontroller.fetchTasks(
        widget.userId,
        selectedDate,
      );
      setState(() => currentTask = task);
    } catch (e) {
      setState(() => currentTask = ViewTaskAdmin.empty(selectedDate));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      await _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF7F3DFF),
        title: Text(
          "User Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient:LinearGradient(
                colors: [
                  Color(0xFF7F3DFF), // Primary Purple
                  Color(0xFFB388FF), // Soft Lavender
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
                borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                _buildDatePicker(),
                SizedBox(height: 10),
                Divider(color: Colors.white54),
                _buildTaskDetails(),
                SizedBox(height: 20),
                _buildApplyButton(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('yyyy-MM-dd').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails() {
    return Column(
      children: [
        Text(
          currentTask?.taskName ?? "Loading...",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(
          currentTask?.projectName ?? "-",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        SizedBox(height: 10),
        Text(
          currentTask?.taskDescription ?? "Loading task details...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: _loadTasks,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      ),
      child: Text(
        "Apply Date",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7F3DFF),
        ),
      ),
    );
  }
}