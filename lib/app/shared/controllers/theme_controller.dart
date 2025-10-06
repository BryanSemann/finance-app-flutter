import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.dark; // Padrão escuro
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeController() {
    _loadTheme();
  }

  // Carregar tema das preferências
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 2; // 2 = dark por padrão
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      // Se houver erro, manter o padrão escuro
      _themeMode = ThemeMode.dark;
    }
  }

  // Salvar tema nas preferências
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Ignorar erro de salvamento
    }
  }

  // Alternar tema
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
    await _saveTheme();
  }

  // Definir tema específico
  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveTheme();
    }
  }

  // Usar tema do sistema
  Future<void> setSystemTheme() async {
    await setTheme(ThemeMode.system);
  }

  // Forçar tema claro
  Future<void> setLightTheme() async {
    await setTheme(ThemeMode.light);
  }

  // Forçar tema escuro
  Future<void> setDarkTheme() async {
    await setTheme(ThemeMode.dark);
  }
}
