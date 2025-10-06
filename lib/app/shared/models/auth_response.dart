import 'user.dart';

class AuthResponse {
  final bool success;
  final String? token;
  final User? user;
  final String? message;
  final Map<String, dynamic>? errors;

  AuthResponse({
    required this.success,
    this.token,
    this.user,
    this.message,
    this.errors,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      success: map['success'] ?? false,
      token: map['token'] ?? map['data']?['token'],
      user: map['user'] != null
          ? User.fromMap(map['user'])
          : map['data']?['user'] != null
          ? User.fromMap(map['data']['user'])
          : null,
      message: map['message'] ?? '',
      errors: map['errors'],
    );
  }

  factory AuthResponse.success({
    required String token,
    User? user,
    String? message,
  }) {
    return AuthResponse(
      success: true,
      token: token,
      user: user,
      message: message ?? 'Autenticação realizada com sucesso',
    );
  }

  factory AuthResponse.error({
    required String message,
    Map<String, dynamic>? errors,
  }) {
    return AuthResponse(success: false, message: message, errors: errors);
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'token': token,
      'user': user?.toMap(),
      'message': message,
      'errors': errors,
    };
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, token: ${token != null ? '[HIDDEN]' : 'null'}, user: $user, message: $message)';
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}

class RegisterRequest {
  final String name;
  final String username;
  final String email;
  final String password;

  RegisterRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
