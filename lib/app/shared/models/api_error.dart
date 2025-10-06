class ApiError {
  final String code;
  final dynamic message;
  final int statusCode;

  ApiError({
    required this.code,
    required this.message,
    required this.statusCode,
  });

  factory ApiError.fromMap(Map<String, dynamic> map) {
    return ApiError(
      code: map['code'] ?? 'UNKNOWN_ERROR',
      message: map['message'] ?? 'Erro desconhecido',
      statusCode: map['status'] ?? map['statusCode'] ?? 500,
    );
  }

  Map<String, dynamic> toMap() {
    return {'code': code, 'message': message, 'statusCode': statusCode};
  }

  factory ApiError.fromException(Exception exception, [int statusCode = 500]) {
    return ApiError(
      code: 'EXCEPTION_ERROR',
      message: exception.toString(),
      statusCode: statusCode,
    );
  }

  factory ApiError.networkError([String? message]) {
    return ApiError(
      code: 'NETWORK_ERROR',
      message: message ?? 'Erro de conexão com o servidor',
      statusCode: 0,
    );
  }

  factory ApiError.unauthorized([String? message]) {
    return ApiError(
      code: 'UNAUTHORIZED',
      message: message ?? 'Não autorizado',
      statusCode: 401,
    );
  }

  factory ApiError.forbidden([String? message]) {
    return ApiError(
      code: 'FORBIDDEN',
      message: message ?? 'Acesso negado',
      statusCode: 403,
    );
  }

  factory ApiError.notFound([String? message]) {
    return ApiError(
      code: 'NOT_FOUND',
      message: message ?? 'Recurso não encontrado',
      statusCode: 404,
    );
  }

  factory ApiError.validationError(String message) {
    return ApiError(
      code: 'VALIDATION_ERROR',
      message: message,
      statusCode: 400,
    );
  }

  factory ApiError.serverError([String? message]) {
    return ApiError(
      code: 'SERVER_ERROR',
      message: message ?? 'Erro interno do servidor',
      statusCode: 500,
    );
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message, statusCode: $statusCode)';
  }

  // Helpers
  bool get isNetworkError => code == 'NETWORK_ERROR';
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 400;
  bool get isServerError => statusCode >= 500;

  String get displayMessage {
    if (message is String) return message as String;
    if (message is Map)
      return (message as Map)['message']?.toString() ?? 'Erro desconhecido';
    return message.toString();
  }
}
