import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plan_it/modules/applications/view/applications.view.dart';
import 'package:plan_it/modules/calendar/view/calendar.view.dart';
import 'package:plan_it/utils/route.utils.dart';
import '../../../authentication.dart';
import '../../doneApplications/view/doneApplications.view.dart';
import '../../login/view/login.view.dart';
import '../../settingsPage/view/settingsPage.view.dart';
import '../../userProfilePage/view/userProfilePage.view.dart';

class HomePageController extends GetxController {
  final auth = Authentication();

  final greeting = ''.obs;
  RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    setGreeting();
    fetchUserName();
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('userCreds')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          userName.value = userDoc['name'] ?? 'User';
        }
      }
    } catch (e) {
      userName.value = 'User';
    }
  }

  goToLogin() {
    RoutesUtil.offAll(() => LoginView());
  }

  showApplications() {
    RoutesUtil.to(() => ApplicationView());
  }

  goToSettings() {
    RoutesUtil.to(() => SettingsPageView());
  }

  goToUserProfile() {
    RoutesUtil.to(() => UserProfilePageView());
  }

  goToCalendar(){
    RoutesUtil.to(()=>ShiftCalendarView());
  }

  goToApprovedApplications(){
    RoutesUtil.to(()=>DoneApplicationsView());
    // Add required function to fetch the approved applications from the fire-store
  }
}
