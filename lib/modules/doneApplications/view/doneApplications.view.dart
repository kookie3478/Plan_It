import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/doneAppications.controller.dart';

class DoneApplicationsView extends StatelessWidget {
  final DoneApplicationsController controller = Get.put(DoneApplicationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Applications'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Row(
          children: [
            // Approved Applications
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green.shade100,
                    width: double.infinity,
                    child: const Text('Approved Applications',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search by sender name...",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => controller.approvedSearch.value = value,
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final apps = controller.filteredApprovedApps;
                      if (apps.isEmpty) return const Center(child: Text("No matches found"));
                      return ListView.builder(
                        itemCount: apps.length,
                        itemBuilder: (context, index) {
                          final app = apps[index];
                          return buildAppCard(app);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            VerticalDivider(width: 1, color: Colors.grey.shade400),

            // Rejected Applications
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    width: double.infinity,
                    child: const Text('Rejected Applications',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search by sender name...",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => controller.rejectedSearch.value = value,
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final apps = controller.filteredRejectedApps;
                      if (apps.isEmpty) return const Center(child: Text("No matches found"));
                      return ListView.builder(
                        itemCount: apps.length,
                        itemBuilder: (context, index) {
                          final app = apps[index];
                          return buildAppCard(app);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildAppCard(Map<String, dynamic> app) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("From: ${app['senderName']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("To: ${app['recipientName']}"),
            Text("Subject: ${app['subject']}"),
            Text("Date: ${app['date']}"),
            Text("Message: ${app['message']}"),
            if ((app['changeFrom'] ?? '').isNotEmpty &&
                (app['changeTo'] ?? '').isNotEmpty)
              Text("Shift Change: ${app['changeFrom']} ➝ ${app['changeTo']}"),
          ],
        ),
      ),
    );
  }
}
