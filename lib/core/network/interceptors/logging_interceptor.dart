import 'package:dio/dio.dart';
import 'dart:developer' as developer;

/// Interceptor de logging para desenvolvimento
/// Registra detalhes das requisições HTTP
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('🌐 REQUEST: ${options.method} ${options.uri}', name: 'HTTP');

    if (options.data != null) {
      developer.log('📤 REQUEST DATA: ${options.data}', name: 'HTTP');
    }

    if (options.queryParameters.isNotEmpty) {
      developer.log(
        '🔍 QUERY PARAMS: ${options.queryParameters}',
        name: 'HTTP',
      );
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      name: 'HTTP',
    );

    developer.log('📥 RESPONSE DATA: ${response.data}', name: 'HTTP');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ERROR: ${err.type} ${err.requestOptions.uri}',
      name: 'HTTP',
    );

    if (err.response != null) {
      developer.log(
        '💥 ERROR RESPONSE: ${err.response?.statusCode} - ${err.response?.data}',
        name: 'HTTP',
      );
    } else {
      developer.log('💥 ERROR MESSAGE: ${err.message}', name: 'HTTP');
    }

    super.onError(err, handler);
  }
}
