import 'package:flutter/material.dart';

/// Paleta de cores da aplicação baseada no Material 3
class AppColors {
  // Impedir instanciação
  AppColors._();

  // Cores primárias
  static const Color primary = Color(0xFF2E7D32); // Verde escuro
  static const Color primaryLight = Color(0xFF66BB6A); // Verde claro
  static const Color primaryDark = Color(0xFF1B5E20); // Verde mais escuro

  // Cores secundárias
  static const Color secondary = Color(0xFF1976D2); // Azul
  static const Color secondaryLight = Color(0xFF64B5F6); // Azul claro
  static const Color secondaryDark = Color(0xFF0D47A1); // Azul escuro

  // Cores de superficie
  static const Color surface = Color(0xFFFFFFFF); // Branco
  static const Color surfaceDark = Color(0xFF121212); // Preto suave
  static const Color surfaceContainer = Color(0xFFF5F5F5); // Cinza muito claro
  static const Color surfaceContainerDark = Color(0xFF1E1E1E); // Cinza escuro

  // Cores de status
  static const Color success = Color(0xFF4CAF50); // Verde sucesso
  static const Color warning = Color(0xFFFF9800); // Laranja aviso
  static const Color error = Color(0xFFF44336); // Vermelho erro
  static const Color info = Color(0xFF2196F3); // Azul informação

  // Cores de texto
  static const Color onSurface = Color(0xFF000000); // Preto
  static const Color onSurfaceDark = Color(0xFFFFFFFF); // Branco
  static const Color onPrimary = Color(0xFFFFFFFF); // Branco
  static const Color onSecondary = Color(0xFFFFFFFF); // Branco

  // Cores especiais para finanças
  static const Color income = Color(0xFF4CAF50); // Verde para receitas
  static const Color expense = Color(0xFFF44336); // Vermelho para despesas
  static const Color transfer = Color(0xFF2196F3); // Azul para transferências

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFFF44336)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Color Scheme para tema claro
  static ColorScheme get lightColorScheme {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: Color(0xFFE8F5E8),
      onPrimaryContainer: Color(0xFF0D2818),
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: Color(0xFFE3F2FD),
      onSecondaryContainer: Color(0xFF0C1B3F),
      tertiary: Color(0xFF6A4C93),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFE8DEF8),
      onTertiaryContainer: Color(0xFF1D192B),
      error: error,
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceContainer,
      onSurfaceVariant: Color(0xFF424242),
      outline: Color(0xFF757575),
      outlineVariant: Color(0xFFE0E0E0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF313033),
      onInverseSurface: Color(0xFFF4EFF4),
      inversePrimary: Color(0xFF90CAF9),
    );
  }

  /// Color Scheme para tema escuro
  static ColorScheme get darkColorScheme {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF81C784),
      onPrimary: Color(0xFF1B5E20),
      primaryContainer: Color(0xFF2E7D32),
      onPrimaryContainer: Color(0xFFE8F5E8),
      secondary: Color(0xFF90CAF9),
      onSecondary: Color(0xFF0D47A1),
      secondaryContainer: Color(0xFF1976D2),
      onSecondaryContainer: Color(0xFFE3F2FD),
      tertiary: Color(0xFFCE93D8),
      onTertiary: Color(0xFF4A148C),
      tertiaryContainer: Color(0xFF6A4C93),
      onTertiaryContainer: Color(0xFFE8DEF8),
      error: Color(0xFFEF5350),
      onError: Color(0xFFB71C1C),
      errorContainer: Color(0xFFF44336),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      surfaceContainerHighest: surfaceContainerDark,
      onSurfaceVariant: Color(0xFFBDBDBD),
      outline: Color(0xFF9E9E9E),
      outlineVariant: Color(0xFF424242),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E1E5),
      onInverseSurface: Color(0xFF313033),
      inversePrimary: primary,
    );
  }
}
