import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../entities/user.dart';

/// Repositório de autenticação (interface)
/// Define os contratos que a camada de dados deve implementar
abstract class AuthRepository {
  /// Fazer login com email e senha
  Future<({Failure? failure, AuthResult? result})> login({
    required String email,
    required String password,
  });

  /// Registrar novo usuário
  Future<({Failure? failure, AuthResult? result})> register({
    required String name,
    required String email,
    required String password,
  });

  /// Fazer logout
  Future<({Failure? failure, bool success})> logout();

  /// Renovar token de acesso
  Future<({Failure? failure, String? token})> refreshToken();

  /// Verificar se usuário está logado
  Future<bool> isLoggedIn();

  /// Obter usuário atual do cache
  Future<({Failure? failure, User? user})> getCurrentUser();

  /// Salvar dados do usuário no cache
  Future<({Failure? failure, bool success})> saveUser(User user);

  /// Salvar token de acesso
  Future<({Failure? failure, bool success})> saveToken(String token);

  /// Salvar refresh token
  Future<({Failure? failure, bool success})> saveRefreshToken(
    String refreshToken,
  );

  /// Limpar todos os dados de autenticação
  Future<({Failure? failure, bool success})> clearAuthData();

  /// Obter token atual
  Future<String?> getToken();

  /// Obter refresh token atual
  Future<String?> getRefreshToken();

  /// Esqueci minha senha
  Future<({Failure? failure, bool success})> forgotPassword({
    required String email,
  });

  /// Redefinir senha
  Future<({Failure? failure, bool success})> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Alterar senha
  Future<({Failure? failure, bool success})> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
