import 'package:dio/dio.dart';
import '../../storage/local_storage.dart';
import '../../config/app_config.dart';

/// Interceptor de autenticação
/// Adiciona automaticamente o token JWT nas requisições
class AuthInterceptor extends Interceptor {
  final LocalStorage _storage = LocalStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Buscar token do storage
    final token = await _storage.getString(AppConfig.tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Se receber 401, tentar refresh token
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storage.getString(AppConfig.refreshTokenKey);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Tentar renovar o token
          final newToken = await _refreshToken(refreshToken);
          if (newToken != null) {
            // Salvar novo token
            await _storage.setString(AppConfig.tokenKey, newToken);

            // Repetir requisição original com novo token
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final response = await Dio().fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } catch (e) {
          // Se refresh falhar, limpar tokens e redirecionar para login
          await _clearAuthData();
        }
      } else {
        // Sem refresh token, limpar dados e redirecionar para login
        await _clearAuthData();
      }
    }

    super.onError(err, handler);
  }

  /// Tentar renovar o token usando refresh token
  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      }
    } catch (e) {
      // Erro no refresh
    }

    return null;
  }

  /// Limpar dados de autenticação
  Future<void> _clearAuthData() async {
    await _storage.remove(AppConfig.tokenKey);
    await _storage.remove(AppConfig.refreshTokenKey);
    await _storage.remove(AppConfig.userKey);

    // Redirecionamento será gerenciado pelo AuthGuard do sistema de roteamento
  }
}
