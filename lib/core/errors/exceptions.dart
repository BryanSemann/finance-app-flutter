/// Exceções customizadas da aplicação
/// Serão convertidas em Failures pelas camadas superiores
library;

/// Exceção base
abstract class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() => message;
}

/// Exceção de rede
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code,
    super.details,
  });
}

/// Exceção de servidor
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error',
    super.code,
    super.details,
  });
}

/// Exceção de autenticação
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication error',
    super.code,
    super.details,
  });
}

/// Exceção de validação
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation error',
    super.code,
    super.details,
  });
}

/// Exceção de cache
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.code,
    super.details,
  });
}

/// Exceção de parsing/serialização
class SerializationException extends AppException {
  const SerializationException({
    super.message = 'Data serialization error',
    super.code,
    super.details,
  });
}
