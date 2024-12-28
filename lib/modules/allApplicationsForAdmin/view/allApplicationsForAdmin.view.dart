import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/modules/allApplicationsForAdmin/controlllers/allApplicationsForAdmin.controller.dart';

class AllApplicationsForAdminView extends StatefulWidget {
  @override
  _AllApplicationsForAdminViewState createState() => _AllApplicationsForAdminViewState();
}

class _AllApplicationsForAdminViewState extends State<AllApplicationsForAdminView> {
  List<Map<String, dynamic>> applications = [];

  AllApplicationsForAdminController allApplicationsForAdminController=AllApplicationsForAdminController();

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  // Fetch applications from Firestore and store them in a local list
  Future<void> fetchApplications() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('applications').get();
      setState(() {
        applications = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Store the document ID
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error fetching applications: $e');
    }
  }

  // Handle application status and remove it from the list
  void handleApplication(String id, String status) {
    setState(() {
      applications.removeWhere((app) => app['id'] == id);
    });
    print('Application $id marked as $status.');
  }


  void showConfirmationDialog(BuildContext context, String id, String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm $status'),
        content: Text('Are you sure you want to $status this application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleApplication(id, status);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications'),
      ),
      body: applications.isEmpty
          ? Center(child: Text('No applications yet.'))
          : ListView.builder(
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          return ListTile(
            title: Text(app['message'] ?? 'No message'),
            subtitle: Text('Status: ${app['status'] ?? 'pending'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => showConfirmationDialog(context, app['id'], 'approved'),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () => showConfirmationDialog(context, app['id'], 'rejected'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
