import 'package:equatable/equatable.dart';
import 'user.dart';

/// Entidade que representa uma resposta de autenticação
class AuthResult extends Equatable {
  final bool success;
  final String? token;
  final String? refreshToken;
  final User? user;
  final String? message;
  final String? errorCode;

  const AuthResult({
    required this.success,
    this.token,
    this.refreshToken,
    this.user,
    this.message,
    this.errorCode,
  });

  /// Factory para sucesso
  factory AuthResult.success({
    required String token,
    String? refreshToken,
    required User user,
    String? message,
  }) {
    return AuthResult(
      success: true,
      token: token,
      refreshToken: refreshToken,
      user: user,
      message: message,
    );
  }

  /// Factory para falha
  factory AuthResult.failure({required String message, String? errorCode}) {
    return AuthResult(success: false, message: message, errorCode: errorCode);
  }

  @override
  List<Object?> get props => [
    success,
    token,
    refreshToken,
    user,
    message,
    errorCode,
  ];
}
