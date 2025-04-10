import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/ViewTaskController.dart';
import '../models/ViewTaskModel.dart';

class ViewTaskScreen extends StatefulWidget {
  @override
  _ViewTaskScreenState createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  final Viewtaskcontroller _taskController = Viewtaskcontroller();
  final List<DateTime> _dates = List.generate(30, (index) => DateTime.now().subtract(Duration(days: index)));
  DateTime _selectedDate = DateTime.now();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _showCalendar = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final tasks = await _taskController.getTasksByDate(_selectedDate);
      setState(() => _tasks = tasks);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load tasks');
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF7F3DFF),
        title: const Center(
          child: Text(
            'View Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildDateCards(),
            const SizedBox(height: 10),
            _buildCalendarToggle(),
            if (_showCalendar) _buildCalendar(),
            const SizedBox(height: 10),
            _isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : _errorMessage != null
                ? Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _loadTasks,
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            )
                : _tasks.isEmpty
                ? const Expanded(
              child: Center(
                child: Text(
                  'No tasks for selected date',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
                : Expanded(child: _buildTasksList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCalendar = !_showCalendar;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEE5FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showCalendar ? Icons.calendar_month : Icons.calendar_today,
              color: const Color(0xFF7F3DFF),
            ),
            const SizedBox(width: 8),
            Text(
              _showCalendar ? 'Hide Calendar' : 'Show Calendar',
              style: const TextStyle(
                color: Color(0xFF7F3DFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDay = focusedDay;
              _showCalendar = false; // Hide calendar after selection
            });
            _loadTasks();
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Color(0xFF7F3DFF),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: const Color(0xFF7F3DFF).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonDecoration: BoxDecoration(
              color: const Color(0xFF7F3DFF),
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            titleCentered: true,
          ),
        ),
      ),
    );
  }

  Widget _buildDateCards() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = isSameDay(date, _selectedDate);
          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              _loadTasks();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: isSelected ? 0 : 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7F3DFF) : const Color(0xFFD6E6FF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.4 : 0.15),
                    blurRadius: isSelected ? 12 : 6,
                    offset: Offset(2, isSelected ? 6 : 4),
                  ),
                ],
              ),
              child: Transform.scale(
                scale: isSelected ? 1.2 : 1.0,
                child: Container(
                  width: isSelected ? 90 : 75,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 18,
                          color: isSelected ? Colors.white : const Color(0xFF7F3DFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getMonthAbbreviation(date.month),
                        style: TextStyle(
                          fontSize: isSelected ? 18 : 14,
                          color: isSelected ? Colors.white : const Color(0xFF7F3DFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date.year.toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 15 : 12,
                          color: isSelected ? Colors.white70 : const Color(0xFF7F3DFF).withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          color: Colors.grey[50],
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.taskName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7F3DFF),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(task.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (task.projectName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.work_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.projectName!,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (task.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      task.description!,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd, yyyy').format(task.startDate),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'to do':
        return Colors.blue;
      default:
        return const Color(0xFF7F3DFF);
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}