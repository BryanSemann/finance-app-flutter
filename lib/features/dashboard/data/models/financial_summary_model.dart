import '../../domain/entities/financial_summary.dart';

/// Model para resumo financeiro
class FinancialSummaryModel extends FinancialSummary {
  const FinancialSummaryModel({
    required super.totalBalance,
    required super.monthlyIncome,
    required super.monthlyExpenses,
    required super.monthlyBalance,
    required super.previousMonthBalance,
    required super.balanceVariation,
    required super.totalTransactions,
    required super.referenceMonth,
  });

  /// Cria a partir de JSON da API
  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinancialSummaryModel(
      totalBalance: (json['total_balance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (json['monthly_expenses'] as num?)?.toDouble() ?? 0.0,
      monthlyBalance: (json['monthly_balance'] as num?)?.toDouble() ?? 0.0,
      previousMonthBalance:
          (json['previous_month_balance'] as num?)?.toDouble() ?? 0.0,
      balanceVariation: (json['balance_variation'] as num?)?.toDouble() ?? 0.0,
      totalTransactions: (json['total_transactions'] as int?) ?? 0,
      referenceMonth: DateTime.parse(json['reference_month'] as String),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'total_balance': totalBalance,
      'monthly_income': monthlyIncome,
      'monthly_expenses': monthlyExpenses,
      'monthly_balance': monthlyBalance,
      'previous_month_balance': previousMonthBalance,
      'balance_variation': balanceVariation,
      'total_transactions': totalTransactions,
      'reference_month': referenceMonth.toIso8601String(),
    };
  }

  /// Cria a partir da entidade do domínio
  factory FinancialSummaryModel.fromEntity(FinancialSummary entity) {
    return FinancialSummaryModel(
      totalBalance: entity.totalBalance,
      monthlyIncome: entity.monthlyIncome,
      monthlyExpenses: entity.monthlyExpenses,
      monthlyBalance: entity.monthlyBalance,
      previousMonthBalance: entity.previousMonthBalance,
      balanceVariation: entity.balanceVariation,
      totalTransactions: entity.totalTransactions,
      referenceMonth: entity.referenceMonth,
    );
  }

  /// Converte para entidade do domínio
  FinancialSummary toEntity() {
    return FinancialSummary(
      totalBalance: totalBalance,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      monthlyBalance: monthlyBalance,
      previousMonthBalance: previousMonthBalance,
      balanceVariation: balanceVariation,
      totalTransactions: totalTransactions,
      referenceMonth: referenceMonth,
    );
  }
}
