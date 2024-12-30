import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:plan_it/utils/const.utils.dart';
import 'package:plan_it/utils/theme.util.dart';

import 'helper/sharedPreferences.helper.dart';
import 'modules/settingsPage/view/settingsPage.view.dart';
import 'modules/wrapper/controller/wrapper.controller.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
      ),
    );

  }else{
    await Firebase.initializeApp();
  }
  await SharedPreferencesHelper.init();
  Get.put(WrapperController(), permanent: true);
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
      home: SettingsPageView(),

    );
  }
}

