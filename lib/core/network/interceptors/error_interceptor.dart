import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

/// Interceptor para tratamento global de erros HTTP
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Converter DioException em AppException personalizada
    final appException = _mapDioExceptionToAppException(err);

    // Rejeitar com a exception customizada
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Timeout na conexão. Verifique sua internet.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Sem conexão com a internet. Verifique sua rede.',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const NetworkException(message: 'Requisição cancelada.');

      case DioExceptionType.unknown:
        return NetworkException(message: 'Erro de conexão: ${error.message}');

      default:
        return NetworkException(
          message: error.message ?? 'Erro de rede desconhecido',
        );
    }
  }

  AppException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    String message = 'Erro no servidor';

    // Tentar extrair mensagem do response
    if (responseData is Map<String, dynamic>) {
      message =
          responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          code: statusCode,
          details: responseData,
        );

      case 401:
        return AuthException(
          message: 'Não autorizado. Faça login novamente.',
          code: statusCode,
          details: responseData,
        );

      case 403:
        return AuthException(
          message: 'Acesso negado. Permissões insuficientes.',
          code: statusCode,
          details: responseData,
        );

      case 404:
        return ServerException(
          message: 'Recurso não encontrado.',
          code: statusCode,
          details: responseData,
        );

      case 422:
        return ValidationException(
          message: 'Dados inválidos.',
          code: statusCode,
          details: responseData,
        );

      case 429:
        return ServerException(
          message: 'Muitas requisições. Tente novamente mais tarde.',
          code: statusCode,
          details: responseData,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Erro interno do servidor. Tente novamente.',
          code: statusCode,
          details: responseData,
        );

      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ValidationException(
            message: message,
            code: statusCode,
            details: responseData,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message,
            code: statusCode,
            details: responseData,
          );
        }

        return ServerException(
          message: message,
          code: statusCode,
          details: responseData,
        );
    }
  }
}
