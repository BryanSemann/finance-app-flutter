import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  late final Dio _dio;
  static ApiService? _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.defaultHeaders,
      ),
    );

    _setupInterceptors();
  }

  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  void _setupInterceptors() {
    // Interceptor para adicionar token de autenticação
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // Tratar erros de autenticação (401)
          if (error.response?.statusCode == 401) {
            // Token expirado - redirecionar para login ou renovar token
            await _handleTokenExpired();
          }

          handler.next(error);
        },
      ),
    );

    // Interceptor para logging (apenas em debug)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // Aqui você pode navegar para tela de login
    // Modular.to.pushReplacementNamed('/login');
  }

  // Métodos HTTP genéricos
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Timeout na conexão. Verifique sua internet.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Erro desconhecido';

        switch (statusCode) {
          case 400:
            return Exception('Requisição inválida: $message');
          case 401:
            return Exception('Não autorizado. Faça login novamente.');
          case 403:
            return Exception('Acesso negado.');
          case 404:
            return Exception('Recurso não encontrado.');
          case 500:
            return Exception('Erro interno do servidor.');
          default:
            return Exception('Erro: $message');
        }

      case DioExceptionType.cancel:
        return Exception('Requisição cancelada.');

      case DioExceptionType.connectionError:
        return Exception('Erro de conexão. Verifique sua internet.');

      default:
        return Exception('Erro inesperado: ${e.message}');
    }
  }
}
