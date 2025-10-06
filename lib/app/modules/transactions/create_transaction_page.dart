import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../shared/models/transaction_category.dart';
import 'transactions_controller.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TransactionsController controller;

  // Controladores dos campos
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  // Valores do formulário
  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  ValueInputType _valueInputType = ValueInputType.total;
  bool _isInstallment = false;
  int _totalInstallments = 2;

  // Valores calculados
  double _totalAmount = 0.0;
  double _installmentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<TransactionsController>();
    _amountController.addListener(_onAmountChanged);

    // Garantir que as categorias estão carregadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.categories.isEmpty) {
        controller.loadCategories();
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final text = _amountController.text.replaceAll(RegExp(r'[^\d,]'), '');
    if (text.isNotEmpty) {
      final value = double.tryParse(text.replaceAll(',', '.')) ?? 0.0;
      _calculateAmounts(value);
    }
  }

  void _calculateAmounts(double inputValue) {
    setState(() {
      if (_isInstallment) {
        if (_valueInputType == ValueInputType.total) {
          _totalAmount = inputValue;
          _installmentAmount = inputValue / _totalInstallments;
        } else {
          _installmentAmount = inputValue;
          _totalAmount = inputValue * _totalInstallments;
        }
      } else {
        _totalAmount = inputValue;
        _installmentAmount = inputValue;
      }
    });
  }

  List<TransactionCategory> get _availableCategories {
    return controller.getCategoriesByType(_selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
        actions: [
          TextButton(onPressed: _saveTransaction, child: const Text('Salvar')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildCategoryField(),
            const SizedBox(height: 16),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildInstallmentSection(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 32),
            _buildPreviewCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo da Transação',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTypeOption(TransactionType.expense)),
                const SizedBox(width: 16),
                Expanded(child: _buildTypeOption(TransactionType.income)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(TransactionType type) {
    final isSelected = _selectedType == type;
    final color = type == TransactionType.income ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null; // Reset category when type changes
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : null,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(type.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              type.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Valor', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: _isInstallment
                    ? '${_valueInputType.label} (R\$)'
                    : 'Valor (R\$)',
                prefixIcon: const Icon(Icons.attach_money),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o valor';
                }
                final numValue = double.tryParse(value.replaceAll(',', '.'));
                if (numValue == null || numValue <= 0) {
                  return 'Informe um valor válido';
                }
                return null;
              },
            ),
            if (_isInstallment) ...[
              const SizedBox(height: 16),
              _buildValueInputTypeSelector(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueInputTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<ValueInputType>(
            title: const Text('Valor Total'),
            value: ValueInputType.total,
            groupValue: _valueInputType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _valueInputType = value;
                  _onAmountChanged(); // Recalculate
                });
              }
            },
          ),
        ),
        Expanded(
          child: RadioListTile<ValueInputType>(
            title: const Text('Por Parcela'),
            value: ValueInputType.installment,
            groupValue: _valueInputType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _valueInputType = value;
                  _onAmountChanged(); // Recalculate
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        hintText: 'Ex: Almoço no restaurante',
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Informe uma descrição';
        }
        if (value.trim().length < 3) {
          return 'Descrição muito curta';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<TransactionCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: _availableCategories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Text(category.icon),
              const SizedBox(width: 8),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (category) {
        setState(() {
          _selectedCategory = category;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Selecione uma categoria';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Data da Transação'),
      subtitle: Text(
        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: _selectDate,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildInstallmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Parcelamento',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: _isInstallment,
                  onChanged: (value) {
                    setState(() {
                      _isInstallment = value;
                      if (!value) {
                        _totalInstallments = 1;
                        _valueInputType = ValueInputType.total;
                      } else {
                        _totalInstallments = 2;
                      }
                      _onAmountChanged(); // Recalculate
                    });
                  },
                ),
              ],
            ),
            if (_isInstallment) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Número de parcelas:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _totalInstallments.toDouble(),
                      min: 2,
                      max: 24,
                      divisions: 22,
                      label: '${_totalInstallments}x',
                      onChanged: (value) {
                        setState(() {
                          _totalInstallments = value.round();
                          _onAmountChanged(); // Recalculate
                        });
                      },
                    ),
                  ),
                  Text(
                    '${_totalInstallments}x',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Observações (opcional)',
        hintText: 'Adicione detalhes sobre esta transação',
        prefixIcon: Icon(Icons.note),
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildPreviewCard() {
    if (_totalAmount <= 0) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPreviewRow('Tipo:', _selectedType.label),
            _buildPreviewRow(
              'Valor Total:',
              'R\$ ${_totalAmount.toStringAsFixed(2).replaceAll('.', ',')}',
            ),
            if (_isInstallment) ...[
              _buildPreviewRow('Parcelas:', '${_totalInstallments}x'),
              _buildPreviewRow(
                'Por Parcela:',
                'R\$ ${_installmentAmount.toStringAsFixed(2).replaceAll('.', ',')}',
              ),
            ],
            _buildPreviewRow(
              'Categoria:',
              _selectedCategory?.name ?? 'Não selecionada',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    // Preparar valor baseado no tipo de entrada
    double inputAmount;
    if (_isInstallment) {
      if (_valueInputType == ValueInputType.total) {
        inputAmount = _totalAmount;
      } else {
        inputAmount = _installmentAmount;
      }
    } else {
      inputAmount = _totalAmount;
    }

    final success = await controller.createTransaction(
      description: _descriptionController.text.trim(),
      amount: inputAmount,
      type: _selectedType,
      categoryId: _selectedCategory!.id,
      transactionDate: _selectedDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      isInstallment: _isInstallment,
      totalInstallments: _isInstallment ? _totalInstallments : 1,
      valueInputType: _valueInputType,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transação criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Modular.to.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Erro ao criar transação'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
