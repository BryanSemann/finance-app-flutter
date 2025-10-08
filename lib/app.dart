import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/theme/theme_data.dart';
import 'core/theme/theme_controller.dart';
import 'core/constants/app_strings.dart';

/// Widget principal da aplicação reformulada
class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Modular.get<ThemeController>(),
      builder: (context, _) {
        final themeController = Modular.get<ThemeController>();

        return MaterialApp.router(
          title: AppStrings.appName,

          // Temas usando Clean Architecture
          theme: AppThemeData.lightTheme,
          darkTheme: AppThemeData.darkTheme,
          themeMode: themeController.themeMode,

          // Roteamento
          routerConfig: Modular.routerConfig,

          // Configurações
          debugShowCheckedModeBanner: false,

          // Localização (preparado para internacionalização futura)
          locale: const Locale('pt', 'BR'),

          // Builder para configurações globais
          builder: (context, child) {
            return MediaQuery(
              // Configurar text scale para melhor acessibilidade
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.textScalerOf(
                  context,
                ).clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
