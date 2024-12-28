import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationController extends GetxController{
  TextEditingController recipients = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController message = TextEditingController();

  Future<void> sendApplication(String message, String subject, String date) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final senderId = currentUser.uid;

    final application = {
      'senderId': senderId,
      'message': message,
      'subject': subject,
      'date': date,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending', // Default status
    };

    await FirebaseFirestore.instance.collection('applications').add(application);
  }
}