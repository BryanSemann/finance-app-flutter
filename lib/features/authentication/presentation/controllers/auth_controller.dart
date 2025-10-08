import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';

/// Estados de carregamento da autenticação
enum AuthLoadingState {
  idle,
  loggingIn,
  registering,
  loggingOut,
  checkingAuth,
  forgettingPassword,
  resettingPassword,
  changingPassword,
}

/// Controlador de estado para autenticação usando ChangeNotifier
class AuthController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _isLoggedInUseCase = isLoggedInUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _changePasswordUseCase = changePasswordUseCase;

  // Estados privados
  AuthLoadingState _loadingState = AuthLoadingState.idle;
  User? _currentUser;
  bool _isLoggedIn = false;
  Failure? _lastError;
  String? _successMessage;

  // Getters
  AuthLoadingState get loadingState => _loadingState;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  Failure? get lastError => _lastError;
  String? get successMessage => _successMessage;

  bool get isLoading => _loadingState != AuthLoadingState.idle;
  bool get isLoggingIn => _loadingState == AuthLoadingState.loggingIn;
  bool get isRegistering => _loadingState == AuthLoadingState.registering;
  bool get isLoggingOut => _loadingState == AuthLoadingState.loggingOut;

  /// Limpa o erro atual
  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  /// Limpa a mensagem de sucesso
  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  /// Verifica se o usuário está logado (inicialização)
  Future<void> checkAuthStatus() async {
    if (_loadingState != AuthLoadingState.idle) return;

    _loadingState = AuthLoadingState.checkingAuth;
    _lastError = null;
    notifyListeners();

    try {
      _isLoggedIn = await _isLoggedInUseCase.call();

      if (_isLoggedIn) {
        final userResult = await _getCurrentUserUseCase.call();
        if (userResult.failure != null) {
          _lastError = userResult.failure;
          _isLoggedIn = false;
        } else {
          _currentUser = userResult.user;
        }
      }
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Faz login do usuário
  Future<bool> login({required String email, required String password}) async {
    if (isLoading) return false;

    _loadingState = AuthLoadingState.loggingIn;
    _lastError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _loginUseCase.call(email: email, password: password);

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      }

      if (result.result?.success == true) {
        _currentUser = result.result?.user;
        _isLoggedIn = true;
        _successMessage = 'Login realizado com sucesso!';
        return true;
      }

      _lastError = const AuthFailure(message: 'Login falhou');
      return false;
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Registra novo usuário
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isLoading) return false;

    _loadingState = AuthLoadingState.registering;
    _lastError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _registerUseCase.call(
        name: name,
        email: email,
        password: password,
        confirmPassword: password,
      );

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      }

      if (result.result?.success == true) {
        _currentUser = result.result?.user;
        _isLoggedIn = true;
        _successMessage = 'Registro realizado com sucesso!';
        return true;
      }

      _lastError = const AuthFailure(message: 'Registro falhou');
      return false;
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Faz logout do usuário
  Future<void> logout() async {
    if (_loadingState == AuthLoadingState.loggingOut) return;

    _loadingState = AuthLoadingState.loggingOut;
    _lastError = null;
    notifyListeners();

    try {
      final result = await _logoutUseCase.call();

      // Sempre limpar os dados locais
      _currentUser = null;
      _isLoggedIn = false;

      if (result.failure != null && result.failure is! NetworkFailure) {
        _lastError = result.failure;
      }
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Solicita recuperação de senha
  Future<bool> forgotPassword({required String email}) async {
    if (isLoading) return false;

    _loadingState = AuthLoadingState.forgettingPassword;
    _lastError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _forgotPasswordUseCase.call(
        ForgotPasswordParams(email: email),
      );

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      }

      _successMessage = 'Instruções enviadas para seu email!';
      return result.success;
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Redefine senha com token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (isLoading) return false;

    _loadingState = AuthLoadingState.resettingPassword;
    _lastError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _resetPasswordUseCase.call(
        ResetPasswordParams(token: token, newPassword: newPassword),
      );

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      }

      _successMessage = 'Senha redefinida com sucesso!';
      return result.success;
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Altera senha do usuário logado
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (isLoading) return false;

    _loadingState = AuthLoadingState.changingPassword;
    _lastError = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _changePasswordUseCase.call(
        ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

      if (result.failure != null) {
        _lastError = result.failure;
        return false;
      }

      _successMessage = 'Senha alterada com sucesso!';
      return result.success;
    } finally {
      _loadingState = AuthLoadingState.idle;
      notifyListeners();
    }
  }

  /// Atualiza dados do usuário atual
  Future<void> refreshUserData() async {
    if (!_isLoggedIn || isLoading) return;

    final originalState = _loadingState;
    _loadingState = AuthLoadingState.checkingAuth;
    notifyListeners();

    try {
      final result = await _getCurrentUserUseCase.call();
      if (result.failure != null) {
        _lastError = result.failure;
      } else {
        _currentUser = result.user;
      }
    } finally {
      _loadingState = originalState;
      notifyListeners();
    }
  }
}
