import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Parâmetros para solicitar recuperação de senha
class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

/// Use case para solicitar recuperação de senha
class ForgotPasswordUseCase
    implements
        UseCase<({Failure? failure, bool success}), ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<({Failure? failure, bool success})> call(
    ForgotPasswordParams params,
  ) async {
    return await _repository.forgotPassword(email: params.email);
  }
}
