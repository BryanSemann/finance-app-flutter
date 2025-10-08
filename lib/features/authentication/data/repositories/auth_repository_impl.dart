import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Implementação do repositório de autenticação
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<({Failure? failure, AuthResult? result})> login({
    required String email,
    required String password,
  }) async {
    try {
      // Fazer login na API
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Converter para entidade do domínio
      final authResult = response.toEntity();

      if (authResult.success && authResult.token != null) {
        // Salvar token e dados do usuário localmente
        await _localDataSource.saveToken(authResult.token!);

        if (authResult.refreshToken != null) {
          await _localDataSource.saveRefreshToken(authResult.refreshToken!);
        }

        if (authResult.user != null) {
          await _localDataSource.saveUser(
            UserModel.fromEntity(authResult.user!),
          );
        }
      }

      return (failure: null, result: authResult);
    } on AuthException catch (e) {
      return (
        failure: AuthFailure(message: e.message, code: e.code),
        result: null,
      );
    } on ValidationException catch (e) {
      return (
        failure: ValidationFailure(message: e.message, code: e.code),
        result: null,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        result: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        result: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro inesperado no login: $e'),
        result: null,
      );
    }
  }

  @override
  Future<({Failure? failure, AuthResult? result})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Fazer registro na API
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      // Converter para entidade do domínio
      final authResult = response.toEntity();

      if (authResult.success && authResult.token != null) {
        // Salvar token e dados do usuário localmente
        await _localDataSource.saveToken(authResult.token!);

        if (authResult.refreshToken != null) {
          await _localDataSource.saveRefreshToken(authResult.refreshToken!);
        }

        if (authResult.user != null) {
          await _localDataSource.saveUser(
            UserModel.fromEntity(authResult.user!),
          );
        }
      }

      return (failure: null, result: authResult);
    } on AuthException catch (e) {
      return (
        failure: AuthFailure(message: e.message, code: e.code),
        result: null,
      );
    } on ValidationException catch (e) {
      return (
        failure: ValidationFailure(message: e.message, code: e.code),
        result: null,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        result: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        result: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro inesperado no registro: $e'),
        result: null,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> logout() async {
    try {
      // Fazer logout na API (pode falhar, mas não é crítico)
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        // Ignorar erro da API para logout
        // O importante é limpar os dados locais
      }

      // Limpar dados locais
      await _localDataSource.clearAuthData();

      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro inesperado no logout: $e'),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, String? token})> refreshToken() async {
    try {
      final currentRefreshToken = await _localDataSource.getRefreshToken();

      if (currentRefreshToken == null) {
        return (
          failure: const AuthFailure(message: 'Refresh token não encontrado'),
          token: null,
        );
      }

      final newToken = await _remoteDataSource.refreshToken(
        currentRefreshToken,
      );
      await _localDataSource.saveToken(newToken);

      return (failure: null, token: newToken);
    } on AuthException catch (e) {
      // Token expirou ou inválido, limpar dados
      await _localDataSource.clearAuthData();
      return (
        failure: AuthFailure(message: e.message, code: e.code),
        token: null,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        token: null,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        token: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro inesperado ao renovar token: $e',
        ),
        token: null,
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _localDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<({Failure? failure, User? user})> getCurrentUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      return (failure: null, user: userModel);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        user: null,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao obter usuário atual: $e'),
        user: null,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> saveUser(User user) async {
    try {
      await _localDataSource.saveUser(UserModel.fromEntity(user));
      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao salvar usuário: $e'),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> saveToken(String token) async {
    try {
      await _localDataSource.saveToken(token);
      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao salvar token: $e'),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> saveRefreshToken(
    String refreshToken,
  ) async {
    try {
      await _localDataSource.saveRefreshToken(refreshToken);
      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao salvar refresh token: $e'),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> clearAuthData() async {
    try {
      await _localDataSource.clearAuthData();
      return (failure: null, success: true);
    } on CacheException catch (e) {
      return (
        failure: CacheFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao limpar dados: $e'),
        success: false,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _localDataSource.getToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _localDataSource.getRefreshToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<({Failure? failure, bool success})> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return (failure: null, success: true);
    } on ValidationException catch (e) {
      return (
        failure: ValidationFailure(message: e.message, code: e.code),
        success: false,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        success: false,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(
          message: 'Erro ao solicitar recuperação: $e',
        ),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return (failure: null, success: true);
    } on ValidationException catch (e) {
      return (
        failure: ValidationFailure(message: e.message, code: e.code),
        success: false,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        success: false,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao redefinir senha: $e'),
        success: false,
      );
    }
  }

  @override
  Future<({Failure? failure, bool success})> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return (failure: null, success: true);
    } on AuthException catch (e) {
      return (
        failure: AuthFailure(message: e.message, code: e.code),
        success: false,
      );
    } on ValidationException catch (e) {
      return (
        failure: ValidationFailure(message: e.message, code: e.code),
        success: false,
      );
    } on NetworkException catch (e) {
      return (
        failure: NetworkFailure(message: e.message, code: e.code),
        success: false,
      );
    } on ServerException catch (e) {
      return (
        failure: ServerFailure(message: e.message, code: e.code),
        success: false,
      );
    } catch (e) {
      return (
        failure: UnexpectedFailure(message: 'Erro ao alterar senha: $e'),
        success: false,
      );
    }
  }
}
