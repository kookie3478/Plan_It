import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationController extends GetxController {
  TextEditingController subject = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController changeFrom = TextEditingController();
  TextEditingController changeTo = TextEditingController();
  TextEditingController group = TextEditingController();

  RxList<Map<String, dynamic>> usersList = <Map<String, dynamic>>[].obs;
  var adminList = <Map<String, dynamic>>[].obs;
  RxString selectedRecipientUid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupAdmins();
  }

  // To get the group ID of the current user
  Future<String> getCurrentUserGroup() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('userCreds').doc(uid).get();
    return doc['group'];
  }

  var isLoadingAdmins = true.obs;

  Future<void> fetchGroupAdmins() async {
    try {
      isLoadingAdmins.value = true;
      final currentGroup = await getCurrentUserGroup();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('userCreds')
          .where('role', isEqualTo: 'Admin')
          .where('group', isEqualTo: currentGroup)
          .get();

      adminList.value = querySnapshot.docs.map((doc) => {
        'uid': doc.id,
        'name': doc['name'],
      }).toList();
    } finally {
      isLoadingAdmins.value = false;
    }
  }



  Future<void> loadRecipients() async {
    final snapshot = await FirebaseFirestore.instance.collection('userCreds').get();

    usersList.value = snapshot.docs.map((doc) {
      return {
        'uid': doc.id,
        'name': doc['name'],
      };
    }).toList();
  }

  Future<void> sendApplication({
    required String message,
    required String subject,
    required String date,
    required String changeFrom,
    required String changeTo,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || selectedRecipientUid.value.isEmpty) return;

    final senderId = currentUser.uid;
    final currentGroup = await getCurrentUserGroup();

    final application = {
      'senderId': senderId,
      'recipientId': selectedRecipientUid.value,
      'message': message,
      'subject': subject,
      'date': date,
      'changeFrom': changeFrom,
      'changeTo': changeTo,
      'group': currentGroup,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    };

    await FirebaseFirestore.instance.collection('applications').add(application);
  }

}
