import 'dart:math';

/// Extensions úteis para tipos nativos do Dart

extension StringExtensions on String {
  /// Capitalizar primeira letra
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizar primeira letra de cada palavra
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Verificar se é um e-mail válido
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Verificar se é um número válido
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Remover acentos e caracteres especiais
  String get removeAccents {
    const withAccents = 'àáäâèéëêìíïîòóöôùúüûñç';
    const withoutAccents = 'aaaaeeeeiiiioooouuuunc';

    String result = this;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
      result = result.replaceAll(
        withAccents[i].toUpperCase(),
        withoutAccents[i].toUpperCase(),
      );
    }
    return result;
  }

  /// Truncar string com reticências
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  /// Converter para slug (URL-friendly)
  String get toSlug {
    return toLowerCase().removeAccents
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// Mascarar string (útil para senhas, etc)
  String mask({String char = '*', int visibleChars = 0}) {
    if (length <= visibleChars) return this;
    final visible = substring(0, visibleChars);
    final masked = char * (length - visibleChars);
    return visible + masked;
  }
}

extension DateTimeExtensions on DateTime {
  /// Verificar se é hoje
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  /// Verificar se é ontem
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return day == yesterday.day &&
        month == yesterday.month &&
        year == yesterday.year;
  }

  /// Verificar se é amanhã
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return day == tomorrow.day &&
        month == tomorrow.month &&
        year == tomorrow.year;
  }

  /// Início do dia
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Final do dia
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Início do mês
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Final do mês
  DateTime get endOfMonth {
    return DateTime(
      year,
      month + 1,
      1,
    ).subtract(const Duration(microseconds: 1));
  }

  /// Adicionar dias úteis (sem fins de semana)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Obter idade em anos
  int get age {
    final now = DateTime.now();
    int age = now.year - year;

    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }

    return age;
  }

  /// Formato relativo (ex: "há 2 dias", "em 1 semana")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'há $years ano${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'há $months mês${months > 1 ? 'es' : ''}';
    } else if (difference.inDays > 0) {
      return 'há ${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'agora';
    }
  }
}

extension DoubleExtensions on double {
  /// Arredondar para N casas decimais
  double roundToDecimals(int decimals) {
    final factor = pow(10, decimals).toDouble();
    return (this * factor).round() / factor;
  }

  /// Converter para porcentagem
  String toPercentage([int decimals = 1]) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Verificar se está dentro de um range
  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }

  /// Clampar valor entre min e max
  double clamp(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

extension ListExtensions<T> on List<T> {
  /// Remover duplicatas mantendo a ordem
  List<T> get unique {
    final seen = <T>{};
    return where(seen.add).toList();
  }

  /// Dividir lista em chunks
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Encontrar elemento ou null
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// Agrupar por critério
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      (map[key] ??= []).add(item);
    }
    return map;
  }
}
