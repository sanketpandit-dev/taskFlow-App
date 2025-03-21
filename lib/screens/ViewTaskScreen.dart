import 'package:flutter/material.dart';

class ViewTaskScreen extends StatefulWidget {
  @override
  _ViewTaskScreen createState() => _ViewTaskScreen();
}

class _ViewTaskScreen extends State<ViewTaskScreen> {
  final List<DateTime> dates = List.generate(30, (index) => DateTime.now().subtract(Duration(days: index)));
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF7F3DFF),
        title: Center(
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
        decoration: BoxDecoration(
          color: Colors.white
          // gradient: LinearGradient(
          //   colors: [Color(0xFF1E3A8A), Color(0xFF6366F1)], // Gradient effect for a premium look
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildDateCards(),
            SizedBox(height: 35),
            _buildTaskDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCards() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.day == selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 6, vertical: isSelected ? 0 : 6),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF7F3DFF) : Color(0xFFD6E6FF),
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
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getMonthAbbreviation(date.month),
                        style: TextStyle(
                          fontSize: isSelected ? 18 : 14,
                          color: Colors.white70,
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

  Widget _buildTaskDetails() {
    return Expanded(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xFF9062E8),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Task Details',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(color: Colors.white70, thickness: 1.5),
                SizedBox(height: 15),
                _buildTaskInfo("Task Title", "Design UI"),
                _buildTaskInfo("Status", "In Progress"),
                _buildTaskInfo("Project", "Task Manager"),
                _buildTaskInfo("Description", "Implement UI"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}
