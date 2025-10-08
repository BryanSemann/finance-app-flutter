import '../models/user_model.dart';

/// Interface para data source local de autenticação
abstract class AuthLocalDataSource {
  /// Salvar token de acesso
  Future<void> saveToken(String token);

  /// Obter token de acesso
  Future<String?> getToken();

  /// Salvar refresh token
  Future<void> saveRefreshToken(String refreshToken);

  /// Obter refresh token
  Future<String?> getRefreshToken();

  /// Salvar dados do usuário
  Future<void> saveUser(UserModel user);

  /// Obter dados do usuário
  Future<UserModel?> getUser();

  /// Verificar se há token salvo
  Future<bool> hasToken();

  /// Limpar todos os dados de autenticação
  Future<void> clearAuthData();

  /// Verificar se o usuário está logado
  Future<bool> isLoggedIn();
}
