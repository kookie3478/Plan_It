import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/applications/view/applications.view.dart';
import 'package:plan_it/modules/calendar/view/calendar.view.dart';
import 'package:plan_it/modules/home/view/home.view.dart';
import 'package:plan_it/modules/login/view/login.view.dart';
import 'package:plan_it/modules/signUp/view/signUp.view.dart';
import 'package:plan_it/modules/wrapper/view/wrapper.view.dart';
import 'package:plan_it/utils/const.utils.dart';
import 'package:plan_it/utils/theme.util.dart';

import 'helper/sharedPreferences.helper.dart';
import 'modules/settingsPage/view/settingsPage.view.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCrXaIEpuqHRCMdjdIT9EJ-f8zwc2UDnqc",
        authDomain: "planit-9e935.firebaseapp.com",
        projectId: "planit-9e935",
        storageBucket: "planit-9e935.firebasestorage.app",
        messagingSenderId: "128505375577",
        appId: "1:128505375577:web:5a2a247d3d9d33ad1dba48"));
  }else{
    await Firebase.initializeApp();
  }
  await SharedPreferencesHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // It is the main file from where the application starts.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Flutter Demo',
      themeMode: (SharedPreferencesHelper.instance.getBool(ConstUtils.isDark)??false) ? ThemeMode.dark : ThemeMode.light,
      theme: ThemesUtil.light,
      darkTheme: ThemesUtil.dark,
      home: WrapperView(),

    );
  }
}

