import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../adminHomePage/view/adminHomePage.view.dart';
import '../../home/view/home.view.dart';
import '../../login/view/login.view.dart';

class WrapperController extends GetxController {
  RxInt val = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fVal(); // Fetch the user role when the controller is initialized
  }

  Future<void> fVal() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Fetch user role from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('userCreds')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          final storedRole = userDoc.data()?['role'];
          if (storedRole == 'Admin') {
            val.value = 1; // Admin
          } else if (storedRole == 'User') {
            val.value = 2; // Regular User
          } else {
            val.value = 0; // Unknown role, fallback to login
          }
        } else {
          val.value = 0; // No user data found, fallback to login
        }
      } catch (e) {
        print("Error fetching user role: $e");
        val.value = 0; // Error fallback
      }
    } else {
      val.value = 0; // User not logged in
    }
  }

  Widget checkUserLoggedIn() {
    return Obx(() {
      // Reactively update UI based on val
      if (val.value == 0) {
        return LoginView();
      } else if (val.value == 1) {
        return AdminHomePageView();
      } else {
        return HomeView();
      }
    });
  }
}
