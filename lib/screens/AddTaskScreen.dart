import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/ProjectController.dart';
import '../controller/StatusController.dart';
import '../controller/TaskController.dart';
import '../models/ProjectModel.dart';
import '../models/StatusModel.dart';
import '../models/TaskModel.dart';
import 'UserDashScreen.dart';

class TaskScreen extends StatefulWidget {
  final String jwtToken;
  final int userId;

  const TaskScreen({Key? key, required this.jwtToken, required this.userId}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final ProjectController _projectController = ProjectController();
  final StatusController _statusController = StatusController();
  final TaskController _taskController = TaskController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Project> _projects = [];

  Project? _selectedProject;

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  String _selectedStatusName = 'Select Status';
  int? _selectedStatusId;
  List<Status> _statuses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final projects = await _projectController.fetchProjects();
      final statuses = await _statusController.fetchStatuses();
      setState(() {
        _projects = projects;
        _statuses = statuses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedStatusName== 'Select Status' ||
        _selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newTask = TaskModel(
        projectID: _selectedProject!.projectID,
        taskName: _titleController.text,
        taskDescription: _descriptionController.text,
        startDate: _selectedDate,
        endDate: _selectedDate,
        statusId: _selectedStatusId!,
        createdBy: widget.userId,
      );
      print('Sending Task Data: ${newTask.toJson()}');

      final isSuccess = await _taskController.addTask(newTask, widget.jwtToken);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Userdashscreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add task')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildDateContainer(),
                const SizedBox(height: 24),
                _buildProjectDropdown(),
                const SizedBox(height: 16),
                _buildStatusDropdown(),
                const SizedBox(height: 16),
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 24),
                _buildAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TASK MANAGEMENT',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Add task details below',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF7F3DFF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDateContainer() {
    final formattedDate = DateFormat('MM-d-yyyy').format(_selectedDate);
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF7F3DFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<Project>(
            isExpanded: true,
            value: _selectedProject,
            hint: const Text('Select Project'),
            icon: const Icon(Icons.arrow_drop_down),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 14,
            ),
            onChanged: (Project? newValue) {
              setState(() => _selectedProject = newValue);
            },
            items: _projects.map<DropdownMenuItem<Project>>((Project project) {
              return DropdownMenuItem<Project>(
                value: project,
                child: Text(project.projectName),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    final statusItems = _statuses.where((s) => s.lookupType == 'Status').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45, // Match other dropdowns' height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300, // Match your other dropdown's border
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16), // Standard padding
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedStatusName,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.grey.shade800, // Match text color
              fontSize: 14,
            ),
            underline: Container(), // Remove default underline
            onChanged: (String? newValue) {
              if (newValue == null || newValue == 'Select Status') return;

              setState(() {
                _selectedStatusName = newValue;
                _selectedStatusId = statusItems
                    .firstWhere((s) => s.lookupName == newValue)
                    .lookupID;
              });
            },
            items: [
              const DropdownMenuItem(
                value: 'Select Status',
                child: Text('Select Status'),
              ),
              ...statusItems.map((status) => DropdownMenuItem(
                value: status.lookupName,
                child: Text(
                  status.lookupName,
                  style: const TextStyle(fontSize: 14), // Consistent text style
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Title',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter task title here',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter task description here...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _addTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7F3DFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}