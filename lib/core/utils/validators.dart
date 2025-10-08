import '../constants/app_strings.dart';

/// Validadores para formulários
class AppValidators {
  /// Validar campo obrigatório
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName é obrigatório'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validar e-mail
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  /// Validar senha
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < minLength) {
      return 'Senha deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Validar confirmação de senha
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value != originalPassword) {
      return AppStrings.passwordsDontMatch;
    }

    return null;
  }

  /// Validar CPF
  static String? cpf(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Remove formatação
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return 'CPF inválido';
    }

    // Valida primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(numbers[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    if (int.parse(numbers[9]) != firstDigit) {
      return 'CPF inválido';
    }

    // Valida segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(numbers[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    if (int.parse(numbers[10]) != secondDigit) {
      return 'CPF inválido';
    }

    return null;
  }

  /// Validar CNPJ
  static String? cnpj(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Remove formatação
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return 'CNPJ inválido';
    }

    // Validação do primeiro dígito
    const weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(numbers[i]) * weights1[i];
    }
    int remainder = sum % 11;
    int firstDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(numbers[12]) != firstDigit) {
      return 'CNPJ inválido';
    }

    // Validação do segundo dígito
    const weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(numbers[i]) * weights2[i];
    }
    remainder = sum % 11;
    int secondDigit = remainder < 2 ? 0 : 11 - remainder;

    if (int.parse(numbers[13]) != secondDigit) {
      return 'CNPJ inválido';
    }

    return null;
  }

  /// Validar telefone brasileiro
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Remove formatação
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.length != 10 && numbers.length != 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    // Verifica se o DDD é válido (11-99)
    final ddd = int.tryParse(numbers.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return 'DDD inválido';
    }

    return null;
  }

  /// Validar valor monetário
  static String? currency(String? value, {double? minValue, double? maxValue}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Remove formatação e converte
    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();

    final numericValue = double.tryParse(cleanValue);
    if (numericValue == null) {
      return 'Valor inválido';
    }

    if (numericValue <= 0) {
      return 'Valor deve ser maior que zero';
    }

    if (minValue != null && numericValue < minValue) {
      return 'Valor mínimo é R\$ ${minValue.toStringAsFixed(2)}';
    }

    if (maxValue != null && numericValue > maxValue) {
      return 'Valor máximo é R\$ ${maxValue.toStringAsFixed(2)}';
    }

    return null;
  }

  /// Validar data
  static String? date(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Tenta parsear data no formato dd/MM/yyyy
    final dateParts = value.split('/');
    if (dateParts.length != 3) {
      return 'Use o formato dd/mm/aaaa';
    }

    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) {
      return 'Data inválida';
    }

    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
      return 'Data inválida';
    }

    try {
      DateTime(year, month, day);
    } catch (e) {
      return 'Data inválida';
    }

    return null;
  }

  /// Combinar múltiplos validadores
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }
}
