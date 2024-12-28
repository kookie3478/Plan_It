import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _singleton = SharedPreferencesHelper._internal();
  static late final SharedPreferences prefs;

  static SharedPreferencesHelper get instance => _singleton;

  factory SharedPreferencesHelper() {
    return _singleton;
  }

  SharedPreferencesHelper._internal();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  clearAllData() async {
    await prefs.clear();
  }

  deleteData(String key) {
    prefs.remove(key);
  }
}