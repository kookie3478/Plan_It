import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemesUtil {
  ThemeMode currentTheme = ThemeMode.light;
  getTheme() => currentTheme;
  setTheme(ThemeMode themeMode) {
    currentTheme = themeMode;
    Get.changeThemeMode(themeMode);
  }

  switchTheme() {
    if (Get.isDarkMode) {
      currentTheme = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      currentTheme = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: "Acumin Pro",
    colorScheme: const ColorScheme.light(
      primary: Colors.deepPurpleAccent,
      secondary: CupertinoColors.systemPurple,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF0F1011),
      primaryContainer: Colors.blue,
      onPrimaryContainer: Color(0xFF0F1011),
      outline: Color(0xFFA4AAB1),
      outlineVariant: Color(0xFF8FC0FF),
      scrim: Colors.green,
      surfaceTint: Color(0xFFD94231),
      surfaceContainer: Color(0xFFF63D33),
      shadow: Color(0xFFE3E5E7),
      surfaceBright: Color(0xFF2F8AFF),
      inversePrimary: Color(0xFFFFC530),
      onSurfaceVariant: Color(0xFFEFF6FF),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF0F1011),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF8F8F9),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Color(0xFFA4AAB1),
      unselectedItemColor: Color(0xFFA4AAB1),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      headerForegroundColor: Color(0xFF0F1011),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      yearForegroundColor: MaterialStatePropertyAll(Color(0xFF0F1011)),
      dividerColor: Color(0xFFA4AAB1),
    ),
  );
  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: "Acumin Pro",
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0053BE),
      onPrimary: Colors.white,
      surface: Color(0xFF131A22),
      onSurface: Color(0xFFFEFEFE),
      primaryContainer: Color(0xFF1F2C34),
      onPrimaryContainer: Color(0xFFFFFFFF),
      outline: Color(0xFF8795A0),
      outlineVariant: Color(0xFF8FC0FF),
      scrim: Color(0xFF15BC00),
      surfaceTint: Color(0xFFD94231),
      shadow: Color(0xFF2E414C),
      surfaceBright: Color(0xFF2F8AFF),
      onSurfaceVariant: Color(0xFF2E414C),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF131A22),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFFEFEFE),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1F2C34),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Color(0xFF8795A0),
      unselectedItemColor: Color(0xFF8795A0),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Color(0xFF1F2C34),
      surfaceTintColor: Color(0xFF1F2C34),
      headerForegroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      yearForegroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFF8FC0FF),
          ),
        )),
  );
}
