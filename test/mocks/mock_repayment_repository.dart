import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';

class MockRepaymentRepository implements RepaymentRepository {
  final Map<int, List<Repayment>> _repayments = {};

  @override
  Future<void> addRepayment(Repayment repayment) async {
    _repayments.putIfAbsent(repayment.transactionId, () => []).add(repayment);
  }

  @override
  Future<List<Repayment>> getRepaymentsByTransactionId(int transactionId) async {
    return _repayments[transactionId] ?? [];
  }

  @override
  Future<void> deleteRepayment(int id) async {
    for (final list in _repayments.values) {
      list.removeWhere((r) => r.id == id);
    }
  }
}
