import 'package:equatable/equatable.dart';

/// Transação recente para o dashboard
class RecentTransaction extends Equatable {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final DateTime date;
  final bool isPending;

  const RecentTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.date,
    required this.isPending,
  });

  /// Valor formatado com sinal
  String get formattedAmount {
    final prefix = type == TransactionType.income ? '+' : '-';
    return '$prefix R\$ ${amount.toStringAsFixed(2)}';
  }

  /// Cor baseada no tipo
  String get typeColor {
    return type == TransactionType.income ? '#4CAF50' : '#F44336';
  }

  @override
  List<Object?> get props => [
    id,
    description,
    amount,
    type,
    categoryName,
    categoryIcon,
    categoryColor,
    date,
    isPending,
  ];
}

/// Tipo de transação
enum TransactionType {
  income('income', 'Receita'),
  expense('expense', 'Despesa');

  const TransactionType(this.value, this.label);
  final String value;
  final String label;
}
