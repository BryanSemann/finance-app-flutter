import 'package:flutter_modular/flutter_modular.dart';
import 'package:finance_app/app/modules/splash/splash_module.dart';
import 'package:finance_app/app/shared/services/api_service.dart';
import 'package:finance_app/app/shared/services/auth_service.dart';

import 'package:finance_app/app/shared/guards/auth_guard.dart';
import 'package:finance_app/mock_test_page.dart';
import 'package:finance_app/dashboard_test_page.dart';
import '../modules/dashboard_module.dart';
import '../modules/auth_module.dart';
import '../modules/transactions_module.dart';
import '../modules/reports_module.dart';

import '../core/core.dart';
import '../features/authentication/authentication.dart' as auth;
import '../features/dashboard/dashboard.dart' as dashboard;
import '../features/transactions/transactions.dart' as transactions;
import '../features/reports/reports.dart' as reports;
import 'package:finance_app/app/shared/repositories/transaction_repository.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Legacy services (compatibility)
    i.addSingleton<ApiService>(ApiService.new);
    i.addSingleton<AuthService>(() => AuthService(i.get<ApiService>()));

    // Core dependencies
    i.addSingleton<DioClient>(() => DioClient());
    i.addSingleton<LocalStorage>(() => LocalStorage());

    // Theme controller
    i.addSingleton<ThemeController>(
      () => ThemeController(i.get<LocalStorage>()),
    );

    // Authentication feature dependencies
    _bindAuthDependencies(i);

    // Dashboard feature dependencies
    _bindDashboardDependencies(i);

    // Transactions feature dependencies
    _bindTransactionsDependencies(i);

    // Reports feature dependencies
    _bindReportsDependencies(i);

    // Legacy transaction repository
    i.addSingleton<TransactionRepository>(
      () => TransactionRepository(i.get<ApiService>()),
    );
  }

  void _bindAuthDependencies(Injector i) {
    // Data sources
    i.addLazySingleton<auth.AuthRemoteDataSource>(
      () => auth.AuthRemoteDataSourceImpl(i.get<DioClient>()),
    );
    i.addLazySingleton<auth.AuthLocalDataSource>(
      () => auth.AuthLocalDataSourceImpl(i.get<LocalStorage>()),
    );

    // Repository
    i.addLazySingleton<auth.AuthRepository>(
      () => auth.AuthRepositoryImpl(
        remoteDataSource: i.get<auth.AuthRemoteDataSource>(),
        localDataSource: i.get<auth.AuthLocalDataSource>(),
      ),
    );

    // Use cases
    i.addLazySingleton<auth.LoginUseCase>(
      () => auth.LoginUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.RegisterUseCase>(
      () => auth.RegisterUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.LogoutUseCase>(
      () => auth.LogoutUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.IsLoggedInUseCase>(
      () => auth.IsLoggedInUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.GetCurrentUserUseCase>(
      () => auth.GetCurrentUserUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.ForgotPasswordUseCase>(
      () => auth.ForgotPasswordUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.ResetPasswordUseCase>(
      () => auth.ResetPasswordUseCase(i.get<auth.AuthRepository>()),
    );
    i.addLazySingleton<auth.ChangePasswordUseCase>(
      () => auth.ChangePasswordUseCase(i.get<auth.AuthRepository>()),
    );

    // Controller
    i.addLazySingleton<auth.AuthController>(
      () => auth.AuthController(
        loginUseCase: i.get<auth.LoginUseCase>(),
        registerUseCase: i.get<auth.RegisterUseCase>(),
        logoutUseCase: i.get<auth.LogoutUseCase>(),
        isLoggedInUseCase: i.get<auth.IsLoggedInUseCase>(),
        getCurrentUserUseCase: i.get<auth.GetCurrentUserUseCase>(),
        forgotPasswordUseCase: i.get<auth.ForgotPasswordUseCase>(),
        resetPasswordUseCase: i.get<auth.ResetPasswordUseCase>(),
        changePasswordUseCase: i.get<auth.ChangePasswordUseCase>(),
      ),
    );
  }

  void _bindDashboardDependencies(Injector i) {
    // Repository
    i.addSingleton<dashboard.DashboardRepository>(
      () => dashboard.DashboardRepositoryImpl(
        remoteDataSource: i.get<dashboard.DashboardRemoteDataSource>(),
        localDataSource: i.get<dashboard.DashboardLocalDataSource>(),
      ),
    );

    // Data sources
    i.addSingleton<dashboard.DashboardRemoteDataSource>(
      () => dashboard.DashboardRemoteDataSourceImpl(i.get<DioClient>()),
    );

    i.addSingleton<dashboard.DashboardLocalDataSource>(
      () => dashboard.DashboardLocalDataSourceImpl(i.get<LocalStorage>()),
    );

    // Use cases
    i.addSingleton<dashboard.GetFinancialSummaryUseCase>(
      () => dashboard.GetFinancialSummaryUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );
    i.addSingleton<dashboard.GetDashboardChartsUseCase>(
      () => dashboard.GetDashboardChartsUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );
    i.addSingleton<dashboard.GetRecentTransactionsUseCase>(
      () => dashboard.GetRecentTransactionsUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );
    i.addSingleton<dashboard.GetTodayTransactionsUseCase>(
      () => dashboard.GetTodayTransactionsUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );
    i.addSingleton<dashboard.GetExpensesByCategoryUseCase>(
      () => dashboard.GetExpensesByCategoryUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );
    i.addSingleton<dashboard.GetBalanceEvolutionUseCase>(
      () => dashboard.GetBalanceEvolutionUseCase(
        i.get<dashboard.DashboardRepository>(),
      ),
    );

    // Controller
    i.addSingleton<dashboard.DashboardController>(
      () => dashboard.DashboardController(
        getFinancialSummaryUseCase: i
            .get<dashboard.GetFinancialSummaryUseCase>(),
        getDashboardChartsUseCase: i.get<dashboard.GetDashboardChartsUseCase>(),
        getRecentTransactionsUseCase: i
            .get<dashboard.GetRecentTransactionsUseCase>(),
        getTodayTransactionsUseCase: i
            .get<dashboard.GetTodayTransactionsUseCase>(),
        getExpensesByCategoryUseCase: i
            .get<dashboard.GetExpensesByCategoryUseCase>(),
        getBalanceEvolutionUseCase: i
            .get<dashboard.GetBalanceEvolutionUseCase>(),
      ),
    );
  }

  void _bindTransactionsDependencies(Injector i) {
    // Data sources
    i.addLazySingleton<transactions.TransactionsRemoteDataSource>(
      () => transactions.TransactionsRemoteDataSourceImpl(i.get<DioClient>()),
    );

    // Repository
    i.addLazySingleton<transactions.TransactionsRepository>(
      () => transactions.TransactionsRepositoryImpl(
        remoteDataSource: i.get<transactions.TransactionsRemoteDataSource>(),
      ),
    );

    // Use cases
    i.addLazySingleton<transactions.GetTransactionsUseCase>(
      () => transactions.GetTransactionsUseCase(
        i.get<transactions.TransactionsRepository>(),
      ),
    );
    i.addLazySingleton<transactions.CreateTransactionUseCase>(
      () => transactions.CreateTransactionUseCase(
        i.get<transactions.TransactionsRepository>(),
      ),
    );
    i.addLazySingleton<transactions.DeleteTransactionUseCase>(
      () => transactions.DeleteTransactionUseCase(
        i.get<transactions.TransactionsRepository>(),
      ),
    );

    // Controller
    i.addLazySingleton<transactions.TransactionsController>(
      () => transactions.TransactionsController(
        getTransactionsUseCase: i.get<transactions.GetTransactionsUseCase>(),
        createTransactionUseCase: i
            .get<transactions.CreateTransactionUseCase>(),
        deleteTransactionUseCase: i
            .get<transactions.DeleteTransactionUseCase>(),
      ),
    );
  }

  void _bindReportsDependencies(Injector i) {
    // Data sources
    i.addLazySingleton<reports.ReportsRemoteDataSource>(
      () => reports.ReportsRemoteDataSourceImpl(i.get<DioClient>()),
    );

    // Repository
    i.addLazySingleton<reports.ReportsRepository>(
      () => reports.ReportsRepositoryImpl(
        remoteDataSource: i.get<reports.ReportsRemoteDataSource>(),
        localStorage: i.get<LocalStorage>(),
      ),
    );

    // Use cases
    i.addLazySingleton<reports.GenerateExpenseReportUseCase>(
      () => reports.GenerateExpenseReportUseCase(
        i.get<reports.ReportsRepository>(),
      ),
    );
    i.addLazySingleton<reports.GenerateIncomeReportUseCase>(
      () => reports.GenerateIncomeReportUseCase(
        i.get<reports.ReportsRepository>(),
      ),
    );
    i.addLazySingleton<reports.GenerateCategoryReportUseCase>(
      () => reports.GenerateCategoryReportUseCase(
        i.get<reports.ReportsRepository>(),
      ),
    );

    // Controller
    i.addLazySingleton<reports.ReportsController>(
      () => reports.ReportsController(
        generateExpenseReportUseCase: i
            .get<reports.GenerateExpenseReportUseCase>(),
        generateIncomeReportUseCase: i
            .get<reports.GenerateIncomeReportUseCase>(),
        generateCategoryReportUseCase: i
            .get<reports.GenerateCategoryReportUseCase>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    // Rota inicial - Splash Screen
    r.module('/', module: SplashModule());

    // Authentication module
    r.module('/auth', module: AuthModule());

    // Dashboard module
    r.module('/home', module: DashboardModule(), guards: [AuthGuard()]);

    // Transactions module
    r.module(
      '/transactions',
      module: TransactionsModule(),
      guards: [AuthGuard()],
    );

    // Reports module
    r.module('/reports', module: ReportsModule(), guards: [AuthGuard()]);

    // Rota temporária para teste de dados mockados
    r.child('/test-mock', child: (context) => const MockTestPage());

    // Test routes
    r.child('/test-dashboard', child: (context) => const DashboardTestPage());
  }
}
