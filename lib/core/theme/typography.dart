import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de tipografia da aplicação
class AppTypography {
  // Impedir instanciação
  AppTypography._();

  /// Família de fonte base (usando Google Fonts)
  static String get fontFamily => GoogleFonts.inter().fontFamily!;

  /// Text Theme base
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme(
      const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontSize: 57,
          height: 64 / 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          height: 52 / 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w400,
        ),

        // Headline styles
        headlineLarge: TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),

        // Body styles
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),

        // Label styles
        labelLarge: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Estilos customizados para contextos específicos

  /// Estilo para valores monetários grandes (dashboard)
  static TextStyle get currencyLarge => const TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Estilo para valores monetários médios (listas)
  static TextStyle get currencyMedium => const TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Estilo para valores monetários pequenos (cards)
  static TextStyle get currencySmall => const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Estilo para botões primários
  static TextStyle get buttonPrimary => const TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Estilo para botões secundários
  static TextStyle get buttonSecondary => const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
  );

  /// Estilo para captions (legendas)
  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  /// Estilo para overlines (sobrescritos)
  static TextStyle get overline => const TextStyle(
    fontSize: 10,
    height: 16 / 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  /// Estilo para números de transação
  static TextStyle get transactionNumber => const TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.8,
    fontFamily: 'Courier', // Monospace para números
  );

  /// Estilo para títulos de seções
  static TextStyle get sectionTitle => const TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// Estilo para subtítulos de seções
  static TextStyle get sectionSubtitle => const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
}
