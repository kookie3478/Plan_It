import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/shifts.component.dart';

class SettingsController extends GetxController {
  var shifts = <Shift>[].obs;
  final _prefsKey = 'user_shifts';

  @override
  void onInit() {
    super.onInit();
    loadShifts();
  }

  void addShift(Shift shift) {
    if (!shifts.any((s) => s.name == shift.name)) {
      shifts.add(shift);
      saveShifts();
    }
  }

  void removeShift(Shift shift) {
    shifts.remove(shift);
    saveShifts();
  }

  Future<void> saveShifts() async {
    final prefs = await SharedPreferences.getInstance();
    final shiftJsonList =
    shifts.map((shift) => json.encode(shift.toJson())).toList();
    await prefs.setStringList(_prefsKey, shiftJsonList);
  }

  Future<void> loadShifts() async {
    final prefs = await SharedPreferences.getInstance();
    final shiftJsonList = prefs.getStringList(_prefsKey);
    if (shiftJsonList != null) {
      final loadedShifts = shiftJsonList
          .map((jsonStr) => Shift.fromJson(json.decode(jsonStr)))
          .toList();
      shifts.assignAll(loadedShifts);
    }
  }
}
