import 'package:get/get.dart';

class RoutesUtil {
  static to (Function page) => Get.to(page, transition: Transition.leftToRight, duration: const Duration(milliseconds: 200));
  static off (Function page) => Get.off(page, transition: Transition.leftToRight, duration: const Duration(milliseconds: 200));
  static offAll (Function page) => Get.offAll(page, transition: Transition.leftToRight, duration: const Duration(milliseconds: 200));
}