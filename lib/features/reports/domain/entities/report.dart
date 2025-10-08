import 'package:equatable/equatable.dart';

/// Entidade que representa um relatório no domínio da aplicação
class Report extends Equatable {
  const Report({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.transactionCount,
    required this.categories,
    required this.createdAt,
  });

  final String id;
  final String title;
  final ReportType type;
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;
  final int transactionCount;
  final List<ReportCategory> categories;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    startDate,
    endDate,
    totalAmount,
    transactionCount,
    categories,
    createdAt,
  ];
}

/// Tipos de relatório disponíveis
enum ReportType {
  expense('expense', 'Despesas'),
  income('income', 'Receitas'),
  category('category', 'Por Categoria'),
  balance('balance', 'Balanço');

  const ReportType(this.value, this.displayName);

  final String value;
  final String displayName;
}

/// Categoria dentro de um relatório
class ReportCategory extends Equatable {
  const ReportCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });

  final String name;
  final double amount;
  final double percentage;
  final int transactionCount;

  @override
  List<Object?> get props => [name, amount, percentage, transactionCount];
}
