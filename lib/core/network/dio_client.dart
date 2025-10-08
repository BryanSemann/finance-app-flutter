import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../errors/exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Cliente HTTP centralizado usando Dio
/// Responsável por toda comunicação com a API
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio();
    _setupInterceptors();
    _setupOptions();
  }

  Dio get dio => _dio;

  void _setupOptions() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  void _setupInterceptors() {
    // Interceptor de autenticação (adiciona token automaticamente)
    _dio.interceptors.add(AuthInterceptor());

    // Interceptor de logging (apenas em desenvolvimento)
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    // Interceptor de tratamento de erros
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// GET request
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
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
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
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
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
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
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
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Tratamento centralizado de erros
  AppException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkException(message: 'Request timeout');

        case DioExceptionType.connectionError:
          return const NetworkException(message: 'Connection error');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? error.message;

          if (statusCode == 401) {
            return AuthException(message: message, code: statusCode);
          } else if (statusCode == 403) {
            return AuthException(message: message, code: statusCode);
          } else if (statusCode == 404) {
            return ServerException(
              message: 'Resource not found',
              code: statusCode,
            );
          } else if (statusCode != null &&
              statusCode >= 400 &&
              statusCode < 500) {
            return ValidationException(message: message, code: statusCode);
          } else if (statusCode != null && statusCode >= 500) {
            return ServerException(message: message, code: statusCode);
          }
          break;

        case DioExceptionType.cancel:
          return const NetworkException(message: 'Request cancelled');

        case DioExceptionType.unknown:
          return NetworkException(
            message: error.message ?? 'Unknown network error',
          );

        default:
          break;
      }
    }

    return NetworkException(message: error.toString());
  }
}
