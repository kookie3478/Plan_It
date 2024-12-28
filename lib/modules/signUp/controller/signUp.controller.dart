import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/authentication.dart';
import '../../../utils/route.utils.dart';
import '../../login/view/login.view.dart';

class SignUpController extends GetxController {
  final _auth = Authentication();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController missNum = TextEditingController();
  final TextEditingController role = TextEditingController();

  goToLogin() {
    RoutesUtil.offAll(() => LoginView());
  }


  Future<void> signUp(String email, String password, String name,
      String role) async {
    try {
      // 1. Create the user with email and password
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save the additional data (name and role) in Firestore
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('userCreds')
            .doc(user.uid)
            .set({
          'name': name,
          'role': role, // 'User' or 'Admin'
          'email': email,
        });
      }
    } catch (e) {
      print("Signup Error: $e");
      // Handle error (show message to user)
    }
  }

  void handleSignup(BuildContext context, String email, String password,
      String name, String role) async {
    if (name.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Name and role must be provided!'),
      ));
      return;
    }

    try {
      // Call signUp function to register user
      await signUp(email, password, name, role);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signup successful!'),
      ));
      RoutesUtil.offAll(()=>LoginView());
      // Redirect user to home screen or login page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup failed: $e'),
      ));
    }
  }
}