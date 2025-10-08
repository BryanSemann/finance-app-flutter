import 'package:equatable/equatable.dart';

/// Base class para todas as falhas na aplicação
/// Segue o padrão Either&lt;Failure, Success&gt; para tratamento de erros
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// Falha de conectividade/rede
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network connection error',
    super.code,
    super.details,
  });
}

/// Falha de servidor (5xx)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
    super.details,
  });
}

/// Falha de autorização (401, 403)
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code,
    super.details,
  });
}

/// Falha de validação (400)
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation error',
    super.code,
    super.details,
  });
}

/// Falha de cache/armazenamento local
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
    super.details,
  });
}

/// Falha genérica para casos não mapeados
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
  });
}

/// Falha de não encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code,
    super.details,
  });
}
