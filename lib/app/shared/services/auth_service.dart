import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../constants/api_constants.dart';
import '../constants/dev_config.dart';
import '../models/user.dart';
import '../models/api_error.dart';
import '../models/auth_response.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // Fazer login
  Future<AuthResponse> login(String email, String password) async {
    // Verificar se está em modo de desenvolvimento
    if (ApiConstants.isDevelopmentMode && DevConfig.isDevMode) {
      return await _developmentLogin(email, password);
    }

    // Login normal via API
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final response = await _apiService.post(
        '${ApiConstants.auth}/login',
        data: loginRequest.toMap(),
      );

      final authResponse = AuthResponse.fromMap(response.data);

      if (authResponse.success && authResponse.token != null) {
        await _saveToken(authResponse.token!);
        if (authResponse.user != null) {
          await _saveUser(authResponse.user!);
        }
      }

      return authResponse;
    } catch (e) {
      if (e is DioException) {
        return _handleDioError(e);
      }
      return AuthResponse.error(message: 'Erro no login: $e');
    }
  }

  // Login de desenvolvimento (funciona offline)
  Future<AuthResponse> _developmentLogin(String email, String password) async {
    // Verificar credenciais predefinidas
    if (ApiConstants.devCredentials.containsKey(email) &&
        ApiConstants.devCredentials[email] == password) {
      // Salvar token de desenvolvimento
      await _saveToken(ApiConstants.devToken);
      await _saveDevelopmentUser(email);

      // Criar usuário de desenvolvimento
      final devUser = User(
        uuid: 'dev-uuid-${email.hashCode}',
        name: 'Dev User',
        username: email.split('@')[0],
        email: email,
        statusCode: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _saveUser(devUser);

      return AuthResponse.success(
        token: ApiConstants.devToken,
        user: devUser,
        message: 'Login de desenvolvimento realizado com sucesso',
      );
    }

    return AuthResponse.error(message: 'Credenciais inválidas');
  }

  // Fazer logout
  Future<void> logout() async {
    try {
      await _apiService.post('${ApiConstants.auth}/logout');
    } catch (e) {
      // Mesmo se der erro na API, remover token local
    } finally {
      await _removeToken();
    }
  }

  // Verificar se está logado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Obter token atual
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Salvar token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remover token e dados do usuário
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('dev_user_email');
    await prefs.remove('user_data');
  }

  // Salvar dados do usuário de desenvolvimento
  Future<void> _saveDevelopmentUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dev_user_email', email);
  }

  // Obter email do usuário de desenvolvimento
  Future<String?> getDevelopmentUserEmail() async {
    if (!ApiConstants.isDevelopmentMode || !DevConfig.isDevMode) return null;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dev_user_email');
  }

  // Verificar se está usando login de desenvolvimento
  Future<bool> isDevelopmentLogin() async {
    if (!ApiConstants.isDevelopmentMode || !DevConfig.isDevMode) return false;

    final token = await getToken();
    return token == ApiConstants.devToken;
  }

  // Listar credenciais de desenvolvimento disponíveis
  Map<String, String> getAvailableDevCredentials() {
    return (ApiConstants.isDevelopmentMode && DevConfig.isDevMode)
        ? Map.from(ApiConstants.devCredentials)
        : {};
  }

  // Login rápido para desenvolvimento (sem senha)
  Future<bool> quickDevLogin([String? email]) async {
    if (!ApiConstants.isDevelopmentMode || !DevConfig.isDevMode) return false;

    final devEmail = email ?? ApiConstants.devCredentials.keys.first;
    if (ApiConstants.devCredentials.containsKey(devEmail)) {
      await _saveToken(ApiConstants.devToken);
      await _saveDevelopmentUser(devEmail);
      return true;
    }

    return false;
  }

  // Obter informações do usuário de desenvolvimento atual
  Future<Map<String, dynamic>?> getDevelopmentUserInfo() async {
    final email = await getDevelopmentUserEmail();
    if (email != null) {
      return DevConfig.getTestUserInfo(email);
    }
    return null;
  }

  // Auto login para desenvolvimento (útil para testes)
  Future<bool> autoDevLoginIfEnabled() async {
    if (!ApiConstants.isDevelopmentMode ||
        !DevConfig.isDevMode ||
        !DevConfig.autoLogin) {
      return false;
    }

    // Se já estiver logado, não fazer nada
    if (await isLoggedIn()) {
      return true;
    }

    // Fazer login automático com usuário padrão
    return await quickDevLogin(DevConfig.defaultDevUser);
  }

  // Validar token atual com o backend
  Future<bool> validateToken() async {
    try {
      final response = await _apiService.get('${ApiConstants.auth}/me');

      if (response.statusCode == 200 && response.data != null) {
        final userData = response.data['data'] ?? response.data['user'];
        if (userData != null) {
          final user = User.fromMap(userData);
          await _saveUser(user);
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Renovar token
  Future<AuthResponse> refreshToken() async {
    try {
      final response = await _apiService.post('${ApiConstants.auth}/refresh');

      final authResponse = AuthResponse.fromMap(response.data);

      if (authResponse.success && authResponse.token != null) {
        await _saveToken(authResponse.token!);
        if (authResponse.user != null) {
          await _saveUser(authResponse.user!);
        }
      }

      return authResponse;
    } catch (e) {
      if (e is DioException) {
        return _handleDioError(e);
      }
      return AuthResponse.error(message: 'Erro ao renovar token: $e');
    }
  }

  // Verificar se usuário está ativo
  Future<bool> isUserActive() async {
    final user = await getCurrentUser();
    return user?.isActive ?? false;
  }

  // Registrar novo usuário
  Future<AuthResponse> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      final response = await _apiService.post(
        '${ApiConstants.auth}/register',
        data: registerRequest.toMap(),
      );

      final authResponse = AuthResponse.fromMap(response.data);

      if (authResponse.success && authResponse.token != null) {
        await _saveToken(authResponse.token!);
        if (authResponse.user != null) {
          await _saveUser(authResponse.user!);
        }
      }

      return authResponse;
    } catch (e) {
      if (e is DioException) {
        return _handleDioError(e);
      }
      return AuthResponse.error(message: 'Erro no registro: $e');
    }
  }

  // Salvar dados do usuário
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toMap()));
  }

  // Obter dados do usuário atual
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      try {
        final userMap = json.decode(userData) as Map<String, dynamic>;
        return User.fromMap(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Tratar erros do Dio
  AuthResponse _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 500;
      final responseData = error.response!.data;

      if (responseData is Map<String, dynamic>) {
        final apiError = ApiError.fromMap(responseData);
        return AuthResponse.error(
          message: apiError.displayMessage,
          errors: responseData,
        );
      }

      // Tratar códigos de status específicos
      switch (statusCode) {
        case 401:
          return AuthResponse.error(message: 'Email ou senha inválidos');
        case 403:
          return AuthResponse.error(message: 'Acesso negado');
        case 422:
          return AuthResponse.error(
            message: 'Dados inválidos',
            errors: responseData,
          );
        case 500:
          return AuthResponse.error(message: 'Erro interno do servidor');
        default:
          return AuthResponse.error(message: 'Erro no servidor ($statusCode)');
      }
    } else {
      // Erro de rede
      return AuthResponse.error(
        message: 'Erro de conexão. Verifique sua internet.',
      );
    }
  }
}
