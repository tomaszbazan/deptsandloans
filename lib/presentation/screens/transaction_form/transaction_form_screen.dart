import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/transaction_type.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/repayment_repository.dart';
import '../../../core/notifications/notification_scheduler.dart';
import '../../widgets/reminder_configuration_widget.dart';
import 'transaction_form_view_model.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionRepository transactionRepository;
  final ReminderRepository reminderRepository;
  final RepaymentRepository repaymentRepository;
  final NotificationScheduler notificationScheduler;
  final TransactionType type;
  final int? transactionId;

  const TransactionFormScreen({
    required this.transactionRepository,
    required this.reminderRepository,
    required this.repaymentRepository,
    required this.notificationScheduler,
    required this.type,
    this.transactionId,
    super.key,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late TransactionFormViewModel _viewModel;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocusNode = FocusNode();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    if (widget.transactionId != null) {
      final transaction = await widget.transactionRepository.getById(widget.transactionId!);
      _viewModel = TransactionFormViewModel(
        repository: widget.transactionRepository,
        reminderRepository: widget.reminderRepository,
        repaymentRepository: widget.repaymentRepository,
        notificationScheduler: widget.notificationScheduler,
        type: widget.type,
        existingTransaction: transaction,
      );
      _nameController.text = _viewModel.name;
      _amountController.text = _viewModel.amount?.toString() ?? '';
      _descriptionController.text = _viewModel.description ?? '';
    } else {
      _viewModel = TransactionFormViewModel(
        repository: widget.transactionRepository,
        reminderRepository: widget.reminderRepository,
        repaymentRepository: widget.repaymentRepository,
        notificationScheduler: widget.notificationScheduler,
        type: widget.type,
      );
      _nameFocusNode.requestFocus();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
    return currency.symbol;
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  String? _getLocalizedError(String? errorKey) {
    if (errorKey == null) return null;
    final l10n = AppLocalizations.of(context);
    switch (errorKey) {
      case 'nameRequired':
        return l10n.nameRequired;
      case 'transactionDateRequired':
        return l10n.transactionDateRequired;
      case 'transactionDateMustBePast':
        return l10n.transactionDateMustBePast;
      case 'descriptionTooLong':
        return l10n.descriptionTooLong;
      case 'amountRequired':
        return l10n.amountRequired;
      case 'amountMustBePositive':
        return l10n.amountMustBePositive;
      case 'reminderDateRequired':
        return l10n.reminderDateRequired;
      case 'reminderDateMustBeFuture':
        return l10n.reminderDateMustBeFuture;
      case 'intervalRequired':
        return l10n.intervalRequired;
      case 'intervalOutOfRange':
        return l10n.intervalOutOfRange;
      case 'reminderTypeRequired':
        return l10n.reminderTypeRequired;
      default:
        return errorKey;
    }
  }

  Future<void> _selectDate() async {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final initialDate = _viewModel.dueDate ?? tomorrow;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(tomorrow) ? initialDate : tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(tomorrow.year + 10),
    );

    if (picked != null) {
      _viewModel.setDueDate(picked);
    }
  }

  Future<void> _selectTransactionDate() async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final initialDate = _viewModel.transactionDate;

    final picked = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime(1900, 1, 1), lastDate: todayStart);

    if (picked != null) {
      _viewModel.setTransactionDate(picked);
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

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(labelText: l10n.name, border: const OutlineInputBorder(), errorText: _getLocalizedError(_viewModel.nameError)),
                  onChanged: _viewModel.setName,
                  textInputAction: TextInputAction.next,
                );
              },
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return InkWell(
                  onTap: _selectTransactionDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.transactionDate,
                      border: const OutlineInputBorder(),
                      errorText: _getLocalizedError(_viewModel.transactionDateError),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(_formatDate(_viewModel.transactionDate), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: l10n.amount,
                          border: const OutlineInputBorder(),
                          errorText: _getLocalizedError(_viewModel.amountError),
                          helperText: isEditMode ? l10n.amountCannotBeChanged : null,
                          helperMaxLines: 2,
                        ),
                        enabled: !isEditMode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                        onChanged: (value) {
                          final amount = double.tryParse(value);
                          _viewModel.setAmount(amount);
                        },
                        textInputAction: TextInputAction.next,
                      );
                    },
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
                        onChanged: isEditMode
                            ? null
                            : (value) {
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
                    errorText: _getLocalizedError(_viewModel.descriptionError),
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
                return ReminderConfigurationWidget(
                  isEnabled: _viewModel.enableReminder,
                  reminderType: _viewModel.reminderType,
                  oneTimeReminderDate: _viewModel.oneTimeReminderDate,
                  recurringIntervalDays: _viewModel.recurringIntervalDays,
                  reminderTypeError: _getLocalizedError(_viewModel.reminderTypeError),
                  reminderDateError: _getLocalizedError(_viewModel.reminderDateError),
                  intervalError: _getLocalizedError(_viewModel.intervalError),
                  onEnabledChanged: _viewModel.setEnableReminder,
                  onReminderTypeChanged: _viewModel.setReminderType,
                  onOneTimeReminderDateChanged: _viewModel.setOneTimeReminderDate,
                  onRecurringIntervalDaysChanged: _viewModel.setRecurringIntervalDays,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
