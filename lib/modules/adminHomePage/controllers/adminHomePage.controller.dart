import 'package:get/get.dart';
import 'package:plan_it/modules/allApplicationsForAdmin/view/allApplicationsForAdmin.view.dart';
import 'package:plan_it/modules/calendar/view/calendar.view.dart';
import 'package:plan_it/utils/route.utils.dart';
import '../../../authentication.dart';
import '../../login/view/login.view.dart';

class AdminHomePageController extends GetxController{
  final auth = Authentication();
  goToLogin(){
    RoutesUtil.offAll(()=>LoginView());
  }

  openCalendar(){
    RoutesUtil.to(()=>CalendarView());
  }

  showApplications(){
    RoutesUtil.to(()=>AllApplicationsForAdminView());
  }

}