import 'package:shared_preferences/shared_preferences.dart';

/// Implementação do LocalStorage usando SharedPreferences
class SharedPrefsStorage {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final prefs = await _preferences;
    return prefs.setString(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    final prefs = await _preferences;
    return prefs.setInt(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final prefs = await _preferences;
    return prefs.setBool(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    final prefs = await _preferences;
    return prefs.setDouble(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return prefs.setStringList(key, value);
  }

  Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    final prefs = await _preferences;
    return prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  Future<Set<String>> getKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }
}
