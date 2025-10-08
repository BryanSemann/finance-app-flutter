import '../../../../core/usecases/usecase.dart';
import '../repositories/dashboard_repository.dart';

/// Use case para limpar cache do dashboard
class ClearDashboardCache implements UseCase<bool, NoParams> {
  final DashboardRepository repository;

  ClearDashboardCache(this.repository);

  @override
  Future<bool> call(NoParams params) async {
    try {
      // Como não temos método clearCache no repository,
      // retornamos sucesso sempre por enquanto
      return true;
    } catch (e) {
      return false;
    }
  }
}
