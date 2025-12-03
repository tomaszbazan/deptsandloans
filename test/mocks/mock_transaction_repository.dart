import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:isar_community/isar.dart';

class MockTransactionRepository implements TransactionRepository {
  final Map<int, Transaction> _transactions = {};
  int _nextId = 1;

  @override
  Future<void> create(Transaction transaction) async {
    if (transaction.id == Isar.autoIncrement) {
      transaction.id = _nextId++;
    }
    _transactions[transaction.id] = transaction;
  }

  @override
  Future<Transaction?> getById(int id) async {
    return _transactions[id];
  }

  @override
  Future<List<Transaction>> getByType(TransactionType type) async {
    return _transactions.values.where((t) => t.type == type).toList();
  }

  @override
  Future<void> update(Transaction transaction) async {
    _transactions[transaction.id] = transaction;
  }

  @override
  Future<void> delete(int id) async {
    _transactions.remove(id);
  }

  @override
  Future<void> markAsCompleted(int id) async {
    final transaction = _transactions[id];
    if (transaction != null) {
      transaction.status = TransactionStatus.completed;
      transaction.updatedAt = DateTime.now();
    }
  }
}
