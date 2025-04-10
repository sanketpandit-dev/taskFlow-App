import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/ProjectService.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<Project> projects = [];
  bool isLoading = true;
  ProjectService projectService = ProjectService();
  TextEditingController projectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedProjects = await projectService.getProjects();
      setState(() {
        projects = loadedProjects;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load projects: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _addProject() async {
    if (projectController.text.isNotEmpty) {
      try {
        Navigator.pop(context); // Close dialog first



        final message = await projectService.addProject(projectController.text);





        projectController.clear();


        _loadProjects();


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {

        Navigator.pop(context);
        _showErrorDialog('Failed to add project: $e');
      }
    }
  }

  void _deleteProject(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${projects[index].projectName}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);


              if (projects[index].projectID == null) {
                _showErrorDialog('Cannot delete project without ID');
                return;
              }

              try {

                // showDialog(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (context) => const Center(child: CircularProgressIndicator()),
                // );

                final message = await projectService.deactivateProject(projects[index].projectID!);


                Navigator.pop(context);

                // Refresh projects list
                _loadProjects();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                // Close loading indicator if open
                Navigator.pop(context);
                _showErrorDialog('Failed to delete project: $e');
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Add New Project"),
        content: TextField(
          controller: projectController,
          decoration: InputDecoration(
            hintText: "Enter Project Name",
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7F3DFF)),
            onPressed: _addProject,
            child: const Text("Add",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Manage Projects",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF7F3DFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddProjectDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadProjects,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : projects.isEmpty
            ? const Center(
          child: Text(
            "No projects available. Click + to add one.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  projects[index].projectName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                // subtitle: Text(
                //   "ID: ${projects[index].projectID ?? 'N/A'}",
                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                // ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProject(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}