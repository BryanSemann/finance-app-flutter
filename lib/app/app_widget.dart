import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'shared/theme/app_theme.dart';
import 'shared/controllers/theme_controller.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = Modular.get<ThemeController>();
    _themeController.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Finance App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeController.themeMode,
      routerConfig: Modular.routerConfig,
    );
  }
}
