import 'package:get/get.dart';
import 'package:plan_it/modules/applications/view/applications.view.dart';
import 'package:plan_it/modules/calendar/view/calendar.view.dart';
import 'package:plan_it/utils/route.utils.dart';
import '../../../authentication.dart';
import '../../login/view/login.view.dart';

class HomeController extends GetxController{
  final auth = Authentication();
  late String userName;
  late String Greeting;
  goToLogin(){
    RoutesUtil.offAll(()=>LoginView());
  }

  openCalendar(){
    RoutesUtil.to(()=>CalendarView());
  }

  openCreateApplication(){
    RoutesUtil.to(()=>ApplicationView());
  }

  getUserName(String s){
    userName=s;
  }
}