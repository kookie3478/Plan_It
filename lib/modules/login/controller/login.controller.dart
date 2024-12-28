import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/adminHomePage/view/adminHomePage.view.dart';
import 'package:plan_it/modules/applications/view/applications.view.dart';
import 'package:plan_it/modules/calendar/view/calendar.view.dart';
import '../../../authentication.dart';
import '../../../utils/route.utils.dart';
import '../../forgotPassword/view/forgotPassword.view.dart';
import '../../home/view/home.view.dart';
import '../../signUp/view/signUp.view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController{
  final _auth = Authentication();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController role = TextEditingController();
  bool value=true;
  getRole(String str){
    role.text=str;
    if(role.text=="User"){
      value=true;
    }else{
      value=false;
    }
    //print(role.text);
  }

  // For logging in the users
  login(BuildContext context) async {
    final user = await _auth.loginUserWithEmailAndPassword(email.text, password.text);
    if(user==null){
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content:
          Text("No users with this email are found please consider signing up."),),
      );
    }

    if (user != null) {
      if(role.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Role must be provided!'),
        ));
        return;
      }
      final userDoc = await FirebaseFirestore.instance.collection('userCreds').doc(user.uid).get();
      if (userDoc.exists) {
        final storedRole = userDoc.data()?['role'];

        // 4. Validate if the entered role matches the stored role
        if (storedRole == role.text) {
          // Role matches, proceed to the respective home screen
          if (role.text == 'Admin') {
            RoutesUtil.offAll(()=>AdminHomePageView());
          } else if (role.text == 'User') {
            RoutesUtil.offAll(()=>HomeView());
          }
        } else {
          // Role doesn't match, show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role mismatch. Please enter the correct role.')),
          );
        }
      } else {
        // User document not found in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found. Please try again.')),
        );
      }
    }
  }

  // If the user wants to update the current password the user will be redirected to forget view page
  forgotPassword() {
    RoutesUtil.to(()=>ForgotPasswordView());
  }

  goToSignup() {
    RoutesUtil.offAll(() => SignupView());
  }



}