import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../authentication.dart';
import '../../../utils/route.utils.dart';
import '../../login/view/login.view.dart';

class ForgotPasswordController extends GetxController{
  final TextEditingController email1 = TextEditingController();
  final auth = Authentication();
  final auth1= FirebaseAuth.instance;

  resetPassword() async {
    final email = email1.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Please enter your email first.")),
      );
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email);
      log("Password reset email sent.");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Password reset email sent. Please check your inbox and login again."),
        ),
      );

      // Navigate back to login screen
      RoutesUtil.offAll(() => LoginView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("No user found with this email.")),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again later.")),
        );
      }
    }
  }
}