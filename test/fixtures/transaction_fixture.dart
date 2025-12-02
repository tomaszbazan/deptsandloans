import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:isar_community/isar.dart';

class TransactionFixture {
  static Transaction createTransaction({
    int id = Isar.autoIncrement,
    TransactionType type = TransactionType.debt,
    String name = 'John Doe',
    int amount = 10000,
    Currency currency = Currency.pln,
    String? description,
    DateTime? dueDate,
    TransactionStatus status = TransactionStatus.active,
  }) {
    final now = DateTime.now();
    return Transaction()
      ..id = id
      ..type = type
      ..name = name
      ..amount = amount
      ..currency = currency
      ..description = description
      ..dueDate = dueDate
      ..status = status
      ..createdAt = now
      ..updatedAt = now;
  }
}
