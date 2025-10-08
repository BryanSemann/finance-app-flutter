import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case para registro de novo usuário
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Executar registro
  Future<({Failure? failure, AuthResult? result})> call({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validações
    final validation = _validateInput(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (validation != null) {
      return (failure: validation, result: null);
    }

    // Chamar repositório
    return await _repository.register(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  /// Validar dados de entrada
  ValidationFailure? _validateInput({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    // Nome obrigatório
    if (name.trim().isEmpty) {
      return const ValidationFailure(message: 'Nome é obrigatório');
    }

    // Nome muito curto
    if (name.trim().length < 2) {
      return const ValidationFailure(
        message: 'Nome deve ter pelo menos 2 caracteres',
      );
    }

    // Email obrigatório
    if (email.trim().isEmpty) {
      return const ValidationFailure(message: 'Email é obrigatório');
    }

    // Email inválido
    if (!_isValidEmail(email)) {
      return const ValidationFailure(message: 'Email inválido');
    }

    // Senha obrigatória
    if (password.isEmpty) {
      return const ValidationFailure(message: 'Senha é obrigatória');
    }

    // Senha muito curta
    if (password.length < 6) {
      return const ValidationFailure(
        message: 'Senha deve ter pelo menos 6 caracteres',
      );
    }

    // Confirmação de senha
    if (confirmPassword.isEmpty) {
      return const ValidationFailure(
        message: 'Confirmação de senha é obrigatória',
      );
    }

    // Senhas não coincidem
    if (password != confirmPassword) {
      return const ValidationFailure(message: 'Senhas não coincidem');
    }

    return null;
  }

  /// Validar formato do email
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());
  }
}
