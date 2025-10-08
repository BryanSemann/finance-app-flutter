import '../models/auth_response_model.dart';

/// Interface para data source remoto de autenticação
abstract class AuthRemoteDataSource {
  /// Login com email e senha
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Registrar novo usuário
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout (invalidar token no servidor)
  Future<void> logout();

  /// Renovar token de acesso
  Future<String> refreshToken(String refreshToken);

  /// Esqueci minha senha
  Future<void> forgotPassword({required String email});

  /// Redefinir senha
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Alterar senha
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
