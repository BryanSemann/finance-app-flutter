import 'package:flutter/material.dart';
import '../storage/local_storage.dart';

/// Controller para gerenciar temas na Clean Architecture
class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  final LocalStorage _localStorage;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeController(this._localStorage) {
    _loadThemeMode();
  }

  /// Modo de tema atual
  ThemeMode get themeMode => _themeMode;

  /// Se está em modo escuro
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Se está em modo claro
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Se está seguindo o sistema
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Carrega o modo do tema salvo
  Future<void> _loadThemeMode() async {
    try {
      final savedTheme = await _localStorage.getString(_themeKey);
      if (savedTheme != null) {
        _themeMode = _parseThemeMode(savedTheme);
        notifyListeners();
      }
    } catch (e) {
      // Usar tema do sistema como fallback
      _themeMode = ThemeMode.system;
    }
  }

  /// Define o modo do tema
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      await _localStorage.setString(_themeKey, _themeModeName(mode));
      notifyListeners();
    } catch (e) {
      // Log error ou tratar conforme necessário
    }
  }

  /// Alterna entre modo claro e escuro
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Define tema claro
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Define tema escuro
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Define tema do sistema
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Converte string para ThemeMode
  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Converte ThemeMode para string
  String _themeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Obtém o nome legível do tema atual
  String get currentThemeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  /// Lista de temas disponíveis
  static const List<ThemeOption> availableThemes = [
    ThemeOption(
      mode: ThemeMode.system,
      name: 'Sistema',
      description: 'Segue o tema do dispositivo',
      icon: Icons.brightness_auto,
    ),
    ThemeOption(
      mode: ThemeMode.light,
      name: 'Claro',
      description: 'Tema claro sempre',
      icon: Icons.brightness_high,
    ),
    ThemeOption(
      mode: ThemeMode.dark,
      name: 'Escuro',
      description: 'Tema escuro sempre',
      icon: Icons.brightness_low,
    ),
  ];
}

/// Opção de tema
class ThemeOption {
  final ThemeMode mode;
  final String name;
  final String description;
  final IconData icon;

  const ThemeOption({
    required this.mode,
    required this.name,
    required this.description,
    required this.icon,
  });
}
