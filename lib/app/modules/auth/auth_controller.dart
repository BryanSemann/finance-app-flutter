import 'package:finance_app/app/shared/services/auth_service.dart';
import 'package:finance_app/app/shared/models/user.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  AuthController(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';
  bool get hasError => _errorMessage != null;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Fazer login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authService.login(email, password);

      if (!authResponse.success) {
        _errorMessage = authResponse.message ?? 'Email ou senha inválidos';
        return false;
      }

      _currentUser = authResponse.user;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fazer logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
    } catch (e) {
      debugPrint('Erro no logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verificar se está logado
  Future<bool> checkAuthStatus() async {
    return await _authService.isLoggedIn();
  }

  // Limpar mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Registrar novo usuário
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? username,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authService.register(
        name: name,
        username:
            username ??
            email.split('@')[0], // Use email prefix se não informado
        email: email,
        password: password,
      );

      if (!authResponse.success) {
        _errorMessage =
            authResponse.message ?? 'Erro ao criar conta. Tente novamente.';
        return false;
      }

      _currentUser = authResponse.user;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carregar usuário atual
  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    }
  }

  // Validar token atual
  Future<bool> validateToken() async {
    try {
      final isValid = await _authService.validateToken();
      if (isValid) {
        await loadCurrentUser();
      }
      return isValid;
    } catch (e) {
      debugPrint('Erro ao validar token: $e');
      return false;
    }
  }
}
