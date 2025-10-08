import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case para obter usuário atual
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Executar obtenção do usuário atual
  Future<({Failure? failure, User? user})> call() async {
    return await _repository.getCurrentUser();
  }
}
