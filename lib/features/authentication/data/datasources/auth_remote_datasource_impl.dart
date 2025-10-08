import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';
import '../../../../app/shared/constants/api_constants.dart';
import '../../../../app/shared/constants/dev_config.dart';

/// Implementação do data source remoto de autenticação
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // Verificar se está em modo de desenvolvimento
    if (ApiConstants.isDevelopmentMode && DevConfig.isDevMode) {
      return await _developmentLogin(email, password);
    }

    // Login normal via API
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      return AuthResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro no login: $e');
    }
  }

  /// Login de desenvolvimento (funciona offline)
  Future<AuthResponseModel> _developmentLogin(
    String email,
    String password,
  ) async {
    // Verificar credenciais predefinidas
    if (ApiConstants.devCredentials.containsKey(email) &&
        ApiConstants.devCredentials[email] == password) {
      // Obter informações do usuário de teste
      final testUserInfo = DevConfig.getTestUserInfo(email);

      // Criar usuário de desenvolvimento
      final devUser = UserModel(
        id: 'dev-id-${email.hashCode}',
        uuid: 'dev-uuid-${email.hashCode}',
        name: testUserInfo?['name'] ?? 'Dev User',
        username: email.split('@')[0],
        email: email,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return AuthResponseModel(
        success: true,
        message: 'Login de desenvolvimento realizado com sucesso',
        token: ApiConstants.devToken,
        user: devUser,
      );
    }

    throw const ServerException(
      message: 'Credenciais de desenvolvimento inválidas',
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      return AuthResponseModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro no registro: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post(ApiEndpoints.logout);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro no logout: $e');
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _client.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final newToken = data['access_token'] ?? data['token'];
        if (newToken != null) {
          return newToken.toString();
        }
      }

      throw const ServerException(message: 'Token não retornado pelo servidor');
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro ao renovar token: $e');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _client.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Erro ao solicitar recuperação de senha: $e',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _client.post(
        ApiEndpoints.resetPassword,
        data: {'token': token, 'password': newPassword},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro ao redefinir senha: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.put(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Erro ao alterar senha: $e');
    }
  }
}
