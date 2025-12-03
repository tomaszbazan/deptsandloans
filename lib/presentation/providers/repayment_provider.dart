import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:flutter/foundation.dart';

class RepaymentProvider extends ChangeNotifier {
  final RepaymentRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;

  RepaymentProvider(this._repository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addRepayment({required int transactionId, required double amount, required DateTime when}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final repayment = Repayment()
        ..transactionId = transactionId
        ..amount = (amount * 100).round()
        ..when = when
        ..createdAt = DateTime.now();

      await _repository.addRepayment(repayment);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
