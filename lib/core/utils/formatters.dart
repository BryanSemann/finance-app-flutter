import 'package:intl/intl.dart';

/// Formatadores de dados para diferentes tipos
class AppFormatters {
  /// Formatador de moeda brasileira
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  /// Formatador de data brasileira
  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

  /// Formatador de data e hora brasileira
  static final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  /// Formatador de hora
  static final DateFormat _timeFormatter = DateFormat('HH:mm');

  /// Formatador de mês e ano
  static final DateFormat _monthYearFormatter = DateFormat(
    'MMMM yyyy',
    'pt_BR',
  );

  /// Formatador de número decimal
  static final NumberFormat _decimalFormatter = NumberFormat(
    '#,##0.00',
    'pt_BR',
  );

  /// Formatador de porcentagem
  static final NumberFormat _percentFormatter = NumberFormat.percentPattern(
    'pt_BR',
  );

  // Métodos de formatação

  /// Formatar valor como moeda
  static String formatCurrency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Formatar data
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formatar data e hora
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Formatar hora
  static String formatTime(DateTime dateTime) {
    return _timeFormatter.format(dateTime);
  }

  /// Formatar mês e ano
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Formatar número decimal
  static String formatDecimal(double value) {
    return _decimalFormatter.format(value);
  }

  /// Formatar porcentagem
  static String formatPercent(double value) {
    return _percentFormatter.format(value);
  }

  /// Formatar número compacto (1K, 1M, etc)
  static String formatCompactNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Parse de moeda para double
  static double parseCurrency(String value) {
    // Remove símbolos e converte
    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();

    return double.tryParse(cleanValue) ?? 0.0;
  }

  /// Parse de data brasileira para DateTime
  static DateTime? parseDate(String value) {
    try {
      return _dateFormatter.parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Formatar CNPJ/CPF
  static String formatDocument(String document) {
    // Remove caracteres não numéricos
    final numbers = document.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 11) {
      // CPF: 000.000.000-00
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, 11)}';
    } else if (numbers.length == 14) {
      // CNPJ: 00.000.000/0000-00
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12, 14)}';
    }

    return document; // Retorna original se não for CPF nem CNPJ
  }

  /// Formatar telefone brasileiro
  static String formatPhone(String phone) {
    // Remove caracteres não numéricos
    final numbers = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length == 10) {
      // (00) 0000-0000
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6, 10)}';
    } else if (numbers.length == 11) {
      // (00) 00000-0000
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7, 11)}';
    }

    return phone; // Retorna original se não estiver no formato esperado
  }
}
