import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../controller/LeaveRequestController.dart';
import '../models/LeaveRequestModel.dart';


class LeaveRequestScreen extends StatefulWidget {
  final String jwtToken;
  final int userId;

  const LeaveRequestScreen({
    Key? key,
    required this.jwtToken,
    required this.userId,
  }) : super(key: key);

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _storage = FlutterSecureStorage();
  List<LeaveRequest> _leaveRequests = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final LeaveController _leaveController = LeaveController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  final TextEditingController _reasonController = TextEditingController();

  bool _showForm = true;

  @override
  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
    }



  Future<void> _submitLeaveRequest() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a reason')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _leaveController.submitLeaveRequest(
        jwtToken: widget.jwtToken,
        userId: widget.userId,
        startDate: _startDate,
        endDate: _endDate,
        reason: _reasonController.text,
      );
      _reasonController.clear();
      await _fetchLeaveRequests();
      setState(() => _showForm = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }
  Future<void> _fetchLeaveRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final requests = await _leaveController.getLeaveStatus(userId: widget.userId);
      print("Fetched ${requests.length} leave requests");

      setState(() {
        _leaveRequests = requests;
      });
    } catch (e) {
      print("Error fetching leave requests: $e");
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Leave Request',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xB58000FF),
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(_showForm ? Icons.list : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())

          : _showForm ? _buildRequestForm() : _buildLeaveList(),
    );
  }

  Widget _buildRequestForm() {
    return Padding(
      padding: const EdgeInsets.all(12.0),

      child: Card(
        color: Colors.grey[50],
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDateField('Start Date', _startDate, true),
              SizedBox(height: 16),
              _buildDateField('End Date', _endDate, false),
              SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Container(

                child: ElevatedButton(
                  style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xB58000FF))),
                  onPressed: _submitLeaveRequest,
                  child: Text('Submit Request',
                  style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, bool isStartDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        InkWell(
          onTap: () => _selectDate(context, isStartDate),
          child: InputDecorator(
            decoration: InputDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('yyyy-MM-dd').format(date)),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLeaveList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _leaveRequests.length,
      itemBuilder: (context, index) {
        final request = _leaveRequests[index];
        print("Displaying request: ${request.status}"); // Debugging

        final startDate = DateFormat('MMM dd').format(request.startDate);
        final endDate = DateFormat('MMM dd, yyyy').format(request.endDate);
        final duration = request.endDate.difference(request.startDate).inDays + 1;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('$duration days'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$startDate - $endDate'),
                Text(request.reason),
                Text('Status: ${request.status}', style: TextStyle(fontWeight: FontWeight.bold)), // Debugging
              ],
            ),
            trailing: Chip(
              label: Text(
                request.status,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _getStatusColor(request.status),
            ),
          ),
        );
      },
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default: // pending
        return Colors.orange;
    }
  }
}