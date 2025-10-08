import 'package:equatable/equatable.dart';

/// Entidade de transação
class Transaction extends Equatable {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? notes;
  final bool isRecurring;
  final int? installments;
  final int? currentInstallment;

  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
    this.isRecurring = false,
    this.installments,
    this.currentInstallment,
  });

  @override
  List<Object?> get props => [
    id,
    description,
    amount,
    type,
    category,
    date,
    notes,
    isRecurring,
    installments,
    currentInstallment,
  ];
}

/// Tipos de transação
enum TransactionType {
  income('Receita'),
  expense('Despesa');

  const TransactionType(this.displayName);
  final String displayName;
}
