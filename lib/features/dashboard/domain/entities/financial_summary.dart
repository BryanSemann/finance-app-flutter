import 'package:equatable/equatable.dart';

/// Resumo financeiro do dashboard
class FinancialSummary extends Equatable {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double monthlyBalance;
  final double previousMonthBalance;
  final double balanceVariation;
  final int totalTransactions;
  final DateTime referenceMonth;

  const FinancialSummary({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.monthlyBalance,
    required this.previousMonthBalance,
    required this.balanceVariation,
    required this.totalTransactions,
    required this.referenceMonth,
  });

  /// Calcula a variação percentual em relação ao mês anterior
  double get balanceVariationPercentage {
    if (previousMonthBalance == 0) return 0.0;
    return (balanceVariation / previousMonthBalance.abs()) * 100;
  }

  /// Indica se houve melhora no saldo
  bool get hasImprovement => balanceVariation > 0;

  /// Saldo disponível (total - despesas pendentes)
  double get availableBalance => totalBalance;

  @override
  List<Object?> get props => [
    totalBalance,
    monthlyIncome,
    monthlyExpenses,
    monthlyBalance,
    previousMonthBalance,
    balanceVariation,
    totalTransactions,
    referenceMonth,
  ];
}
