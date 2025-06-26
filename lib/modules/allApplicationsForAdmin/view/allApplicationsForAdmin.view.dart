import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controlllers/allApplicationsForAdmin.controller.dart';

class AllApplicationsForAdminView extends StatefulWidget {
  @override
  _AllApplicationsForAdminViewState createState() => _AllApplicationsForAdminViewState();
}

class _AllApplicationsForAdminViewState extends State<AllApplicationsForAdminView> {
  final AllApplicationsForAdminController controller = Get.put(AllApplicationsForAdminController());

  @override
  void initState() {
    super.initState();
    controller.fetchApplications();
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
              controller.handleApplication(id, status);
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
      appBar: AppBar(title: Text('Applications')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final apps = controller.applications;

        if (apps.isEmpty) {
          return const Center(child: Text('No applications yet.'));
        }

        return ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("From: ${app['senderName']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("To: ${app['recipientName']}"),
                    Text("Subject: ${app['subject']}"),
                    Text("Date: ${app['date']}"),
                    Text("Message: ${app['message']}"),
                    if ((app['changeFrom'] ?? '').isNotEmpty && (app['changeTo'] ?? '').isNotEmpty)
                      Text("Shift Change: ${app['changeFrom']} ➝ ${app['changeTo']}"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.check, color: Colors.green),
                          label: const Text("Approve"),
                          onPressed: () => showConfirmationDialog(context, app['id'], 'approved'),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text("Reject"),
                          onPressed: () => showConfirmationDialog(context, app['id'], 'rejected'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),

    );
  }
}
