import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case para logout do usuário
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Executar logout
  Future<({Failure? failure, bool success})> call() async {
    return await _repository.logout();
  }
}
