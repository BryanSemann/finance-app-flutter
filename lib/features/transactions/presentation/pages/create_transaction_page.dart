import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/transaction.dart';
import '../controllers/transactions_controller.dart';

/// Página para criar nova transação
class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  late final TransactionsController controller;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Alimentação';
  bool _isExpense = true;

  final List<String> _categories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Educação',
    'Lazer',
    'Compras',
    'Investimentos',
    'Salário',
    'Freelance',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    controller = Modular.get<TransactionsController>();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tipo de transação
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipo de Transação',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpense = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _isExpense
                                          ? Theme.of(context).primaryColor
                                                .withValues(alpha: 0.1)
                                          : null,
                                      border: Border.all(
                                        color: _isExpense
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                        width: _isExpense ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.remove_circle_outline,
                                          color: _isExpense
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Despesa',
                                          style: TextStyle(
                                            color: _isExpense
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                            fontWeight: _isExpense
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpense = false;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: !_isExpense
                                          ? Theme.of(context).primaryColor
                                                .withValues(alpha: 0.1)
                                          : null,
                                      border: Border.all(
                                        color: !_isExpense
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                        width: !_isExpense ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: !_isExpense
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Receita',
                                          style: TextStyle(
                                            color: !_isExpense
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                            fontWeight: !_isExpense
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Valor
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira um valor';
                      }
                      final double? amount = double.tryParse(
                        value.replaceAll(',', '.'),
                      );
                      if (amount == null || amount <= 0) {
                        return 'Por favor, insira um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Categoria
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão salvar
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isCreating
                          ? null
                          : _saveTransaction,
                      child: controller.isCreating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar Transação'),
                    ),
                  ),

                  // Mostrar erro se houver
                  if (controller.lastError != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.lastError!.message,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                            IconButton(
                              onPressed: controller.clearError,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final description = _descriptionController.text.trim();
    final amountText = _amountController.text.replaceAll(',', '.');
    final amount = double.parse(amountText);

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      amount: amount,
      type: _isExpense ? TransactionType.expense : TransactionType.income,
      category: _selectedCategory,
      date: DateTime.now(),
    );

    final success = await controller.createTransaction(transaction);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transação criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Modular.to.pop();
    }
  }
}
