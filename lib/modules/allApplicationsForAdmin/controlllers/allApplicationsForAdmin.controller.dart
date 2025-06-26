import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllApplicationsForAdminController extends GetxController {
  RxList<Map<String, dynamic>> applications = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  Future<String> getCurrentUserGroup() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('userCreds').doc(uid).get();
    return doc['group'];
  }

  Future<void> fetchApplications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final group = await getCurrentUserGroup();
    final currentUserId = user.uid;

    isLoading.value = true;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('applications')
          .where('status', isEqualTo: 'pending')
          .where('group', isEqualTo: group)
          .where('recipientId', isEqualTo: currentUserId) // 👈 Filter only those meant for current admin
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> apps = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        final senderSnapshot = await FirebaseFirestore.instance
            .collection('userCreds')
            .doc(data['senderId'])
            .get();
        final recipientSnapshot = await FirebaseFirestore.instance
            .collection('userCreds')
            .doc(data['recipientId'])
            .get();

        data['senderName'] = senderSnapshot['name'];
        data['recipientName'] = recipientSnapshot['name'];

        apps.add(data);
      }

      applications.value = apps;
    } catch (e) {
      print('Error fetching applications: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> handleApplication(String id, String status) async {
    try {
      await FirebaseFirestore.instance.collection('applications').doc(id).update({
        'status': status,
      });

      applications.removeWhere((app) => app['id'] == id);
    } catch (e) {
      print('Error updating application status: $e');
    }
  }
}
