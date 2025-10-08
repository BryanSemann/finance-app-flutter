import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case para login do usuário
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executar login
  Future<({Failure? failure, AuthResult? result})> call({
    required String email,
    required String password,
  }) async {
    // Validações básicas
    if (email.trim().isEmpty) {
      return (
        failure: const ValidationFailure(message: 'Email é obrigatório'),
        result: null,
      );
    }

    if (password.isEmpty) {
      return (
        failure: const ValidationFailure(message: 'Senha é obrigatória'),
        result: null,
      );
    }

    if (!_isValidEmail(email)) {
      return (
        failure: const ValidationFailure(message: 'Email inválido'),
        result: null,
      );
    }

    // Chamar repositório
    return await _repository.login(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  /// Validar formato do email
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());
  }
}
