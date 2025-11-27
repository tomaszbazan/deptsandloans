import 'package:flutter/foundation.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/transaction.dart';
import '../../../data/models/transaction_status.dart';
import '../../../data/models/transaction_type.dart';
import '../../../data/repositories/transaction_repository.dart';

class TransactionFormViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
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

  TransactionFormViewModel({required TransactionRepository repository, required TransactionType type, Transaction? existingTransaction})
    : _repository = repository,
      _type = type,
      _existingTransaction = existingTransaction {
    if (existingTransaction != null) {
      _loadExistingTransaction();
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

  void _loadExistingTransaction() {
    if (_existingTransaction == null) return;

    _name = _existingTransaction.name;
    _amount = _existingTransaction.amountInMainUnit;
    _currency = _existingTransaction.currency;
    _description = _existingTransaction.description;
    _dueDate = _existingTransaction.dueDate;
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

  bool validateForm() {
    _nameError = _validateName(_name);
    _descriptionError = _validateDescription(_description);
    _amountError = _validateAmount(_amount);

    notifyListeners();

    return _nameError == null && _descriptionError == null && _amountError == null;
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
      } else {
        await _repository.create(transaction);
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
