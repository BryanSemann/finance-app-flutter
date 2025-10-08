import 'dart:convert';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementação do data source local de autenticação
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _storage;

  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.setString(AppConfig.tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _storage.getString(AppConfig.tokenKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao obter token: $e');
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.setString(AppConfig.refreshTokenKey, refreshToken);
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar refresh token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.getString(AppConfig.refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao obter refresh token: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toCacheJson());
      await _storage.setString(AppConfig.userKey, userJson);
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar usuário: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = await _storage.getString(AppConfig.userKey);
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        return UserModel.fromCache(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Erro ao obter usuário: $e');
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _storage.remove(AppConfig.tokenKey),
        _storage.remove(AppConfig.refreshTokenKey),
        _storage.remove(AppConfig.userKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar dados de autenticação: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final hasValidToken = await hasToken();
      final user = await getUser();
      return hasValidToken && user != null;
    } catch (e) {
      return false;
    }
  }
}
