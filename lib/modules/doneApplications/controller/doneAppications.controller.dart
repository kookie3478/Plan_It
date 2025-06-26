import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DoneApplicationsController extends GetxController {
  RxList<Map<String, dynamic>> approvedApplications = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> rejectedApplications = <Map<String, dynamic>>[].obs;

  RxString approvedSearch = ''.obs;
  RxString rejectedSearch = ''.obs;

  RxBool isLoading = true.obs;

  Future<String> getCurrentUserGroup() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('userCreds').doc(uid).get();
    return doc['group'];
  }

  List<Map<String, dynamic>> get filteredApprovedApps => approvedApplications
      .where((app) => app['senderName']
      .toLowerCase()
      .contains(approvedSearch.value.toLowerCase()))
      .toList();

  List<Map<String, dynamic>> get filteredRejectedApps => rejectedApplications
      .where((app) => app['senderName']
      .toLowerCase()
      .contains(rejectedSearch.value.toLowerCase()))
      .toList();

  @override
  void onInit() {
    super.onInit();
    fetchDoneApplications();
  }

  Future<void> fetchDoneApplications() async {
    isLoading.value = true;
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final currentUserId = currentUser.uid;
      final currentGroup = await getCurrentUserGroup();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('applications')
          .where('status', whereIn: ['approved', 'rejected'])
          .orderBy('timestamp', descending: true)
          .get();

      List<Map<String, dynamic>> approved = [];
      List<Map<String, dynamic>> rejected = [];

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

        // Skip if group doesn't match
        if ((senderSnapshot['group'] != currentGroup) || (recipientSnapshot['group'] != currentGroup)) {
          continue;
        }

        data['senderName'] = senderSnapshot['name'];
        data['recipientName'] = recipientSnapshot['name'];

        // Only include if current user is the recipient or part of the group
        if (data['recipientId'] == currentUserId || senderSnapshot['group'] == currentGroup) {
          if (data['status'] == 'approved') {
            approved.add(data);
          } else {
            rejected.add(data);
          }
        }
      }

      approvedApplications.value = approved;
      rejectedApplications.value = rejected;
    } catch (e) {
      print('Error fetching done applications: $e');
    } finally {
      isLoading.value = false;
    }
  }

}

