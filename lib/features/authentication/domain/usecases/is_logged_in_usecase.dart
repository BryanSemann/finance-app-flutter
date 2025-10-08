import '../repositories/auth_repository.dart';

/// Use case para verificar se o usuário está logado
class IsLoggedInUseCase {
  final AuthRepository _repository;

  IsLoggedInUseCase(this._repository);

  /// Verificar se está logado
  Future<bool> call() async {
    return await _repository.isLoggedIn();
  }
}
