import 'package:deptsandloans/data/models/repayment.dart';
import 'package:isar_community/isar.dart';

class RepaymentFixture {
  static Repayment createRepayment({int id = Isar.autoIncrement, int transactionId = 1, int amount = 5000, DateTime? when}) {
    final now = DateTime.now();
    return Repayment()
      ..id = id
      ..transactionId = transactionId
      ..amount = amount
      ..when = when ?? now
      ..createdAt = now;
  }
}
