import '../models/transaction.dart';
import '../models/transaction_type.dart';

abstract class TransactionRepository {
  Future<void> create(Transaction transaction);

  Future<List<Transaction>> getByType(TransactionType type);

  Future<void> update(Transaction transaction);

  Future<void> delete(int id);
}
