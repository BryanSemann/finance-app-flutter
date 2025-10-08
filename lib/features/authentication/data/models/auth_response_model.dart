import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

/// Model para resposta de autenticação da API
class AuthResponseModel {
  final bool success;
  final String? token;
  final String? refreshToken;
  final UserModel? user;
  final String? message;
  final String? errorCode;

  const AuthResponseModel({
    required this.success,
    this.token,
    this.refreshToken,
    this.user,
    this.message,
    this.errorCode,
  });

  /// Criar a partir do JSON da API
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      token: json['token'] ?? json['access_token'] ?? json['accessToken'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      message: json['message']?.toString(),
      errorCode: json['error_code']?.toString() ?? json['code']?.toString(),
    );
  }

  /// Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'message': message,
      'error_code': errorCode,
    };
  }

  /// Converter para entidade do domínio
  AuthResult toEntity() {
    return AuthResult(
      success: success,
      token: token,
      refreshToken: refreshToken,
      user: user, // UserModel já extends User
      message: message,
      errorCode: errorCode,
    );
  }

  /// Factory para sucesso
  factory AuthResponseModel.success({
    required String token,
    String? refreshToken,
    required UserModel user,
    String? message,
  }) {
    return AuthResponseModel(
      success: true,
      token: token,
      refreshToken: refreshToken,
      user: user,
      message: message,
    );
  }

  /// Factory para erro
  factory AuthResponseModel.error({
    required String message,
    String? errorCode,
  }) {
    return AuthResponseModel(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }
}
