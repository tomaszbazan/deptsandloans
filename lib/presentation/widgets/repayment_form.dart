import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/providers/repayment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RepaymentForm extends StatefulWidget {
  final RepaymentProvider provider;
  final int transactionId;
  final String transactionName;
  final double remainingBalance;
  final Currency currency;
  final VoidCallback onSuccess;

  const RepaymentForm({
    required this.provider,
    required this.transactionId,
    required this.transactionName,
    required this.remainingBalance,
    required this.currency,
    required this.onSuccess,
    super.key,
  });

  @override
  State<RepaymentForm> createState() => _RepaymentFormState();
}

class _RepaymentFormState extends State<RepaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final fiveYearsAgo = DateTime.now().subtract(const Duration(days: 5 * 365));
    final pickedDate = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: fiveYearsAgo, lastDate: DateTime.now());

    if (pickedDate != null) {
      if (!mounted) return;

      final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDate));

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amountText = _amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(amountText) ?? 0.0;

    final success = await widget.provider.addRepayment(transactionId: widget.transactionId, amount: amount, when: _selectedDate);

    if (!mounted) return;

    if (success) {
      widget.onSuccess();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.provider.errorMessage ?? 'Failed to add repayment'), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  String? _validateAmount(String? value) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.amountRequired;
    }

    final normalizedValue = value.replaceAll(',', '.');
    final amount = double.tryParse(normalizedValue);

    if (amount == null || amount <= 0) {
      return l10n.amountMustBePositive;
    }

    if (amount > widget.remainingBalance) {
      return l10n.repaymentExceedsBalance;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currencySymbol = widget.currency.symbol;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addRepayment, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.transactionName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.balance}: ${CurrencyFormatter.format(amount: widget.remainingBalance, currency: widget.currency, locale: Localizations.localeOf(context))}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: '${l10n.repaymentAmount} *', border: const OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+[.,]?\d{0,2}'))],
                    validator: _validateAmount,
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.currency, border: const OutlineInputBorder()),
                    controller: TextEditingController(text: currencySymbol),
                    enabled: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(labelText: l10n.dueDate, border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_today)),
                child: Text(DateFormat.yMd(Localizations.localeOf(context).toString()).add_jm().format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: widget.provider,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: widget.provider.isLoading ? null : () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: widget.provider.isLoading ? null : _handleSubmit,
                      child: widget.provider.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
