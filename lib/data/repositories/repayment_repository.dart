import '../models/repayment.dart';

abstract class RepaymentRepository {
  Future<void> addRepayment(Repayment repayment);

  Future<List<Repayment>> getRepaymentsByTransactionId(int transactionId);

  Future<void> deleteRepayment(int id);

  Future<double> totalRepaid(int transactionId);
}
