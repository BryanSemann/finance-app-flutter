import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Parâmetros para alterar senha
class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

/// Use case para alterar senha do usuário logado
class ChangePasswordUseCase
    implements
        UseCase<({Failure? failure, bool success}), ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<({Failure? failure, bool success})> call(
    ChangePasswordParams params,
  ) async {
    return await _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
