import 'dart:developer' as developer;
import 'package:isar_community/isar.dart';
import '../models/repayment.dart';
import '../models/transaction.dart';
import '../models/transaction_status.dart';
import '../models/transaction_type.dart';
import 'exceptions/repository_exceptions.dart';
import 'transaction_repository.dart';

class IsarTransactionRepository implements TransactionRepository {
  final Isar _isar;

  const IsarTransactionRepository(this._isar);

  @override
  Future<void> create(Transaction transaction) async {
    try {
      transaction.validate();

      await _isar.writeTxn(() async {
        await _isar.transactions.put(transaction);
      });

      developer.log('Transaction created: id=${transaction.id}, name=${transaction.name}', name: 'TransactionRepository');
    } catch (e, stackTrace) {
      developer.log('Failed to create transaction', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to create transaction', e);
    }
  }

  @override
  Future<Transaction?> getById(int id) async {
    try {
      final transaction = await _isar.transactions.get(id);

      if (transaction != null) {
        developer.log('Retrieved transaction: id=$id, name=${transaction.name}', name: 'TransactionRepository');
      } else {
        developer.log('Transaction not found: id=$id', name: 'TransactionRepository');
      }

      return transaction;
    } catch (e, stackTrace) {
      developer.log('Failed to get transaction by id', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to get transaction by id $id', e);
    }
  }

  @override
  Future<List<Transaction>> getByType(TransactionType type) async {
    try {
      final transactionsWithDueDate = await _isar.transactions.filter().typeEqualTo(type).dueDateIsNotNull().sortByDueDate().findAll();

      final transactionsWithoutDueDate = await _isar.transactions.filter().typeEqualTo(type).dueDateIsNull().findAll();

      final transactions = [...transactionsWithDueDate, ...transactionsWithoutDueDate];

      developer.log('Retrieved ${transactions.length} transactions of type $type', name: 'TransactionRepository');

      return transactions;
    } catch (e, stackTrace) {
      developer.log('Failed to get transactions by type', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to get transactions by type $type', e);
    }
  }

  @override
  Future<void> update(Transaction transaction) async {
    try {
      final existing = await _isar.transactions.get(transaction.id);
      if (existing == null) {
        throw TransactionNotFoundException(transaction.id);
      }

      transaction.validate();

      await _isar.writeTxn(() async {
        await _isar.transactions.put(transaction);
      });

      developer.log('Transaction updated: id=${transaction.id}, name=${transaction.name}', name: 'TransactionRepository');
    } on TransactionNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log('Failed to update transaction', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to update transaction', e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      final deleted = await _isar.writeTxn(() async {
        final repaymentsDeleted = await _isar.repayments.filter().transactionIdEqualTo(id).deleteAll();
        developer.log('Deleted $repaymentsDeleted repayments for transaction $id', name: 'TransactionRepository');

        return await _isar.transactions.delete(id);
      });

      if (!deleted) {
        throw TransactionNotFoundException(id);
      }

      developer.log('Transaction deleted: id=$id', name: 'TransactionRepository');
    } on TransactionNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log('Failed to delete transaction', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to delete transaction', e);
    }
  }

  @override
  Future<void> markAsCompleted(int id) async {
    try {
      final transaction = await _isar.transactions.get(id);
      if (transaction == null) {
        throw TransactionNotFoundException(id);
      }

      if (transaction.status == TransactionStatus.completed) {
        developer.log('Transaction already completed: id=$id', name: 'TransactionRepository');
        return;
      }

      transaction.status = TransactionStatus.completed;
      transaction.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.transactions.put(transaction);
      });

      developer.log('Transaction marked as completed: id=$id, name=${transaction.name}', name: 'TransactionRepository');
    } on TransactionNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log('Failed to mark transaction as completed', name: 'TransactionRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw TransactionRepositoryException('Failed to mark transaction as completed', e);
    }
  }
}
