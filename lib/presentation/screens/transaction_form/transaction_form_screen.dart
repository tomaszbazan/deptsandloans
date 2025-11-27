import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/transaction_type.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'transaction_form_view_model.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionRepository repository;
  final TransactionType type;
  final int? transactionId;

  const TransactionFormScreen({required this.repository, required this.type, this.transactionId, super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late TransactionFormViewModel _viewModel;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewModel = TransactionFormViewModel(repository: widget.repository, type: widget.type);
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.pln:
        return 'PLN';
      case Currency.eur:
        return '€';
      case Currency.usd:
        return '\$';
      case Currency.gbp:
        return '£';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = _viewModel.dueDate ?? now;
    final picked = await showDatePicker(context: context, initialDate: initialDate.isAfter(now) ? initialDate : now, firstDate: now, lastDate: DateTime(now.year + 10));

    if (picked != null) {
      _viewModel.setDueDate(picked);
    }
  }

  Future<void> _handleSave() async {
    final success = await _viewModel.saveTransaction();
    if (success && mounted) {
      context.pop();
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditMode = widget.transactionId != null;
    final title = isEditMode ? l10n.editTransaction : (widget.type == TransactionType.debt ? l10n.addDebt : l10n.addLoan);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return IconButton(
                icon: _viewModel.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
                onPressed: _viewModel.isLoading ? null : _handleSave,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: InputDecoration(labelText: l10n.name, border: const OutlineInputBorder()),
              onChanged: _viewModel.setName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: l10n.amount, border: const OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    onChanged: (value) {
                      final amount = double.tryParse(value);
                      _viewModel.setAmount(amount);
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return DropdownButtonFormField<Currency>(
                        decoration: InputDecoration(labelText: l10n.currency, border: const OutlineInputBorder()),
                        initialValue: _viewModel.currency,
                        items: Currency.values.map((currency) => DropdownMenuItem(value: currency, child: Text(_getCurrencySymbol(currency)))).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _viewModel.setCurrency(value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final description = _viewModel.description ?? '';
                final remaining = 200 - description.length;
                return TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: '${l10n.description} (${l10n.optional})',
                    border: const OutlineInputBorder(),
                    helperText: l10n.charactersRemaining(remaining),
                  ),
                  maxLength: 200,
                  maxLines: 3,
                  onChanged: _viewModel.setDescription,
                  textInputAction: TextInputAction.done,
                );
              },
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '${l10n.dueDate} (${l10n.optional})',
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_viewModel.dueDate != null)
                            IconButton(icon: const Icon(Icons.clear), onPressed: () => _viewModel.setDueDate(null), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                    child: Text(
                      _viewModel.dueDate != null ? _formatDate(_viewModel.dueDate!) : l10n.notSet,
                      style: TextStyle(color: _viewModel.dueDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
