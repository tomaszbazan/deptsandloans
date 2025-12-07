import 'package:flutter/foundation.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/reminder.dart';
import '../../../data/models/reminder_type.dart';
import '../../../data/models/transaction.dart';
import '../../../data/models/transaction_status.dart';
import '../../../data/models/transaction_type.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/repayment_repository.dart';
import '../../../core/notifications/notification_scheduler.dart';

class TransactionFormViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  final ReminderRepository _reminderRepository;
  final RepaymentRepository _repaymentRepository;
  final NotificationScheduler _notificationScheduler;
  final TransactionType _type;
  final Transaction? _existingTransaction;

  String _name = '';
  double? _amount;
  Currency _currency = Currency.pln;
  String? _description;
  DateTime? _dueDate;
  bool _isLoading = false;
  String? _errorMessage;
  String? _nameError;
  String? _descriptionError;
  String? _amountError;

  bool _enableReminder = false;
  ReminderType? _reminderType;
  DateTime? _oneTimeReminderDate;
  int? _recurringIntervalDays;
  String? _reminderTypeError;
  String? _reminderDateError;
  String? _intervalError;
  Reminder? _existingReminder;

  TransactionFormViewModel({
    required TransactionRepository repository,
    required ReminderRepository reminderRepository,
    required RepaymentRepository repaymentRepository,
    required NotificationScheduler notificationScheduler,
    required TransactionType type,
    Transaction? existingTransaction,
  }) : _repository = repository,
       _reminderRepository = reminderRepository,
       _repaymentRepository = repaymentRepository,
       _notificationScheduler = notificationScheduler,
       _type = type,
       _existingTransaction = existingTransaction {
    if (existingTransaction != null) {
      _loadExistingTransaction();
      _loadExistingReminder();
    }
  }

  String get name => _name;

  double? get amount => _amount;

  Currency get currency => _currency;

  String? get description => _description;

  DateTime? get dueDate => _dueDate;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String? get nameError => _nameError;

  String? get descriptionError => _descriptionError;

  String? get amountError => _amountError;

  TransactionType get type => _type;

  bool get isEditMode => _existingTransaction != null;

  bool get enableReminder => _enableReminder;

  ReminderType? get reminderType => _reminderType;

  DateTime? get oneTimeReminderDate => _oneTimeReminderDate;

  int? get recurringIntervalDays => _recurringIntervalDays;

  String? get reminderTypeError => _reminderTypeError;

  String? get reminderDateError => _reminderDateError;

  String? get intervalError => _intervalError;

  void _loadExistingTransaction() {
    if (_existingTransaction == null) return;

    _name = _existingTransaction.name;
    _amount = _existingTransaction.amountInMainUnit;
    _currency = _existingTransaction.currency;
    _description = _existingTransaction.description;
    _dueDate = _existingTransaction.dueDate;
  }

  Future<void> _loadExistingReminder() async {
    if (_existingTransaction == null) return;

    final reminders = await _reminderRepository.getRemindersByTransactionId(_existingTransaction.id);
    if (reminders.isNotEmpty) {
      _existingReminder = reminders.first;
      _enableReminder = true;
      _reminderType = _existingReminder!.type;
      if (_existingReminder!.isOneTime) {
        _oneTimeReminderDate = _existingReminder!.nextReminderDate;
      } else {
        _recurringIntervalDays = _existingReminder!.intervalDays;
      }
      notifyListeners();
    }
  }

  void setName(String value) {
    _name = value;
    _nameError = _validateName(value);
    _clearError();
    notifyListeners();
  }

  void setAmount(double? value) {
    _amount = value;
    _amountError = _validateAmount(value);
    _clearError();
    notifyListeners();
  }

  void setCurrency(Currency value) {
    _currency = value;
    notifyListeners();
  }

  void setDescription(String? value) {
    if (value == null || value.isEmpty) {
      _description = null;
    } else {
      _description = value;
    }
    _descriptionError = _validateDescription(value);
    _clearError();
    notifyListeners();
  }

  void setDueDate(DateTime? value) {
    _dueDate = value;
    notifyListeners();
  }

  void setEnableReminder(bool value) {
    _enableReminder = value;
    if (!value) {
      _reminderType = null;
      _oneTimeReminderDate = null;
      _recurringIntervalDays = null;
      _reminderTypeError = null;
      _reminderDateError = null;
      _intervalError = null;
    }
    _clearError();
    notifyListeners();
  }

  void setReminderType(ReminderType? value) {
    _reminderType = value;
    _oneTimeReminderDate = null;
    _recurringIntervalDays = null;
    _reminderTypeError = null;
    _reminderDateError = null;
    _intervalError = null;
    _clearError();
    notifyListeners();
  }

  void setOneTimeReminderDate(DateTime? value) {
    _oneTimeReminderDate = value;
    _reminderDateError = _validateReminderDate(value);
    _clearError();
    notifyListeners();
  }

  void setRecurringIntervalDays(int? value) {
    _recurringIntervalDays = value;
    _intervalError = _validateInterval(value);
    _clearError();
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'nameRequired';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value != null && value.length > 200) {
      return 'descriptionTooLong';
    }
    return null;
  }

  String? _validateAmount(double? value) {
    if (value == null) {
      return 'amountRequired';
    }
    if (value <= 0) {
      return 'amountMustBePositive';
    }
    return null;
  }

  String? _validateReminderDate(DateTime? value) {
    if (_enableReminder && _reminderType == ReminderType.oneTime) {
      if (value == null) {
        return 'reminderDateRequired';
      }
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDate = DateTime(value.year, value.month, value.day);
      if (selectedDate.isBefore(today)) {
        return 'reminderDateMustBeFuture';
      }
    }
    return null;
  }

  String? _validateInterval(int? value) {
    if (_enableReminder && _reminderType == ReminderType.recurring) {
      if (value == null) {
        return 'intervalRequired';
      }
      if (value <= 0 || value > 365) {
        return 'intervalOutOfRange';
      }
    }
    return null;
  }

  String? _validateReminderType() {
    if (_enableReminder && _reminderType == null) {
      return 'reminderTypeRequired';
    }
    return null;
  }

  bool validateForm() {
    _nameError = _validateName(_name);
    _descriptionError = _validateDescription(_description);
    if (!isEditMode) {
      _amountError = _validateAmount(_amount);
    }

    _reminderTypeError = _validateReminderType();
    _reminderDateError = _validateReminderDate(_oneTimeReminderDate);
    _intervalError = _validateInterval(_recurringIntervalDays);

    notifyListeners();

    return _nameError == null && _descriptionError == null && _amountError == null && _reminderTypeError == null && _reminderDateError == null && _intervalError == null;
  }

  Future<bool> saveTransaction() async {
    if (!validateForm()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final transaction = _buildTransaction();
      transaction.validate();

      if (isEditMode) {
        await _repository.update(transaction);
        await _handleReminderUpdate(transaction.id);
      } else {
        await _repository.create(transaction);
        if (_enableReminder) {
          await _createReminder(transaction.id);
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _handleReminderUpdate(int transactionId) async {
    final existingReminders = await _reminderRepository.getRemindersByTransactionId(transactionId);
    for (final reminder in existingReminders) {
      if (reminder.notificationId != null) {
        await _notificationScheduler.cancelReminder(reminder.notificationId!);
      }
    }

    await _reminderRepository.deleteRemindersByTransactionId(transactionId);

    if (_enableReminder) {
      await _createReminder(transactionId);
    }
  }

  Future<void> _createReminder(int transactionId) async {
    if (_reminderType == null) return;

    final reminder = Reminder()
      ..transactionId = transactionId
      ..type = _reminderType!
      ..createdAt = DateTime.now();

    if (_reminderType == ReminderType.oneTime) {
      final date = _oneTimeReminderDate!;
      reminder.nextReminderDate = DateTime(date.year, date.month, date.day, 19, 0);
      reminder.intervalDays = null;
    } else {
      final now = DateTime.now();
      reminder.intervalDays = _recurringIntervalDays;
      reminder.nextReminderDate = DateTime(now.year, now.month, now.day, 19, 0).add(Duration(days: _recurringIntervalDays!));
    }

    reminder.validate();
    await _reminderRepository.createReminder(reminder);

    if (_reminderType == ReminderType.oneTime) {
      final transaction = await _repository.getById(transactionId);
      if (transaction == null) {
        throw Exception('Transaction not found');
      }
      final repayments = await _repaymentRepository.getRepaymentsByTransactionId(transactionId);
      final totalRepaid = repayments.fold<int>(0, (sum, repayment) => sum + repayment.amount);
      final remainingBalance = (transaction.amount - totalRepaid) / 100.0;
      final locale = _getLocale();
      final notificationId = await _notificationScheduler.scheduleOneTimeReminder(reminder: reminder, transaction: transaction, locale: locale, remainingBalance: remainingBalance);
      reminder.notificationId = notificationId;
      await _reminderRepository.updateReminder(reminder);
    }
  }

  String _getLocale() {
    return 'en';
  }

  Transaction _buildTransaction() {
    final transaction = Transaction()
      ..type = _type
      ..name = _name
      ..amount = ((_amount ?? 0) * 100).round()
      ..currency = _currency
      ..description = _description
      ..dueDate = _dueDate
      ..status = TransactionStatus.active;

    if (isEditMode && _existingTransaction != null) {
      transaction.id = _existingTransaction.id;
      transaction.createdAt = _existingTransaction.createdAt;
      transaction.updatedAt = DateTime.now();
    } else {
      final now = DateTime.now();
      transaction.createdAt = now;
      transaction.updatedAt = now;
    }

    return transaction;
  }
}
