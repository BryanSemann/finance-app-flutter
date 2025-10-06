class Installment {
  final String id;
  final String transactionId;
  final int number; // Número da parcela (1, 2, 3...)
  final int totalInstallments; // Total de parcelas
  final double amount; // Valor desta parcela
  final DateTime dueDate; // Data de vencimento
  final bool isPaid; // Se foi paga
  final DateTime? paidDate; // Quando foi paga
  final String? notes; // Observações da parcela

  Installment({
    required this.id,
    required this.transactionId,
    required this.number,
    required this.totalInstallments,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paidDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'number': number,
      'totalInstallments': totalInstallments,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
      'paidDate': paidDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      id: map['id'] ?? '',
      transactionId: map['transactionId'] ?? '',
      number: map['number'] ?? 1,
      totalInstallments: map['totalInstallments'] ?? 1,
      amount: (map['amount'] ?? 0.0).toDouble(),
      dueDate: DateTime.parse(map['dueDate']),
      isPaid: map['isPaid'] ?? false,
      paidDate: map['paidDate'] != null
          ? DateTime.parse(map['paidDate'])
          : null,
      notes: map['notes'],
    );
  }

  Installment copyWith({
    String? id,
    String? transactionId,
    int? number,
    int? totalInstallments,
    double? amount,
    DateTime? dueDate,
    bool? isPaid,
    DateTime? paidDate,
    String? notes,
  }) {
    return Installment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      number: number ?? this.number,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      notes: notes ?? this.notes,
    );
  }

  // Helpers
  String get displayNumber => '$number/$totalInstallments';
  bool get isOverdue => !isPaid && DateTime.now().isAfter(dueDate);
  bool get isDueToday =>
      !isPaid &&
      DateTime.now().day == dueDate.day &&
      DateTime.now().month == dueDate.month &&
      DateTime.now().year == dueDate.year;
  bool get isLast => number == totalInstallments;

  @override
  String toString() {
    return 'Installment(number: $displayNumber, amount: $amount, dueDate: $dueDate, isPaid: $isPaid)';
  }
}
