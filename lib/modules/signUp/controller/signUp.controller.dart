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
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController group = TextEditingController();
  final TextEditingController role = TextEditingController();

  var selectedRole = ''.obs;  // for button highlighting

  bool value = true;

  void getRole(String str) {
    role.text = str;
    selectedRole.value = str;
    if (str.toLowerCase() == "user") {
      value = true;
    } else {
      value = false;
    }
  }

  goToLogin() {
    RoutesUtil.offAll(() => LoginView());
  }

  Future<void> signUp(String email, String password, String name, String role, String group) async {
    try {
      // Step 1: Register user
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      // Step 2: Ensure user is logged in
      if (user == null) throw Exception("User is null after signup");

      final uid = user.uid;

      // Step 3: Create Firestore document
      final userData = {
        'name': name,
        'role': role,
        'email': email,
        'group':group,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('userCreds').doc(uid).set(userData);

      log("User signed up and data saved for UID: $uid");

    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.code} - ${e.message}");
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      log("General signup error: $e");
      throw Exception('Signup failed: $e');
    }
  }

  void handleSignup(BuildContext context, String email, String password, String name, String role, String group) async {
    if (name.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Name and role must be provided!'),
      ));
      return;
    }

    try {
      await signUp(email, password, name, role, group);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signup successful! Please log in.'),
      ));

      RoutesUtil.offAll(() => LoginView());

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
