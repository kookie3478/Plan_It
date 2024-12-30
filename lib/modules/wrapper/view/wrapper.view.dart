import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/wrapper.controller.dart';

class WrapperView extends StatelessWidget {
  WrapperView({super.key});

  final WrapperController wrapperController = Get.find<WrapperController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wrapperController.checkUserLoggedIn(),
    );
  }
}
