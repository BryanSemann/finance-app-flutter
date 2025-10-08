import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Parâmetros para redefinir senha
class ResetPasswordParams {
  final String token;
  final String newPassword;

  const ResetPasswordParams({required this.token, required this.newPassword});
}

/// Use case para redefinir senha com token
class ResetPasswordUseCase
    implements
        UseCase<({Failure? failure, bool success}), ResetPasswordParams> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<({Failure? failure, bool success})> call(
    ResetPasswordParams params,
  ) async {
    return await _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}
