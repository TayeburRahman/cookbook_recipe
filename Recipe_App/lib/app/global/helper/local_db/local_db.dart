import 'package:shared_preferences/shared_preferences.dart';

class SharePrefsHelper {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get _instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  //===========================Get Data From Shared Preference===================

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await _instance;
    return preferences.getString(key) ?? "";
  }

  static Future<List<String>> getLisOfString(String key) async {
    SharedPreferences preferences = await _instance;
    return preferences.getStringList(key) ?? [];
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences preferences = await _instance;
    return preferences.getBool(key);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences preferences = await _instance;
    return preferences.getInt(key) ?? (-1);
  }

//===========================Save Data To Shared Preference===================

  static Future setString(String key, value) async {
    SharedPreferences preferences = await _instance;
    await preferences.setString(key, value);
  }

  static Future<bool> setListOfString(String key, List<String> value) async {
    SharedPreferences preferences = await _instance;
    return await preferences.setStringList(key, value);
  }

  static Future setBool(String key, bool value) async {
    SharedPreferences preferences = await _instance;
    await preferences.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    SharedPreferences preferences = await _instance;
    await preferences.setInt(key, value);
  }

//===========================Remove Value===================

  static Future remove(String key) async {
    SharedPreferences preferences = await _instance;
    return preferences.remove(key);
  }
}
