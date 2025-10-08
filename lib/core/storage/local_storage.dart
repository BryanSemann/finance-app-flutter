import 'shared_prefs_storage.dart';

/// Classe de conveniência para armazenamento local
/// Atualmente usa SharedPreferences, mas pode ser facilmente trocada
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final SharedPrefsStorage _storage = SharedPrefsStorage();

  // String methods
  Future<String?> getString(String key) => _storage.getString(key);
  Future<bool> setString(String key, String value) =>
      _storage.setString(key, value);

  // Integer methods
  Future<int?> getInt(String key) => _storage.getInt(key);
  Future<bool> setInt(String key, int value) => _storage.setInt(key, value);

  // Boolean methods
  Future<bool?> getBool(String key) => _storage.getBool(key);
  Future<bool> setBool(String key, bool value) => _storage.setBool(key, value);

  // Double methods
  Future<double?> getDouble(String key) => _storage.getDouble(key);
  Future<bool> setDouble(String key, double value) =>
      _storage.setDouble(key, value);

  // List methods
  Future<List<String>?> getStringList(String key) =>
      _storage.getStringList(key);
  Future<bool> setStringList(String key, List<String> value) =>
      _storage.setStringList(key, value);

  // Remove methods
  Future<bool> remove(String key) => _storage.remove(key);
  Future<bool> clear() => _storage.clear();
  Future<bool> containsKey(String key) => _storage.containsKey(key);

  // Get all keys
  Future<Set<String>> getKeys() => _storage.getKeys();
}
