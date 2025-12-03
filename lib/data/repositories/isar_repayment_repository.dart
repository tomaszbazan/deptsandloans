import 'dart:developer' as developer;
import 'package:isar_community/isar.dart';
import '../models/repayment.dart';
import '../models/transaction.dart';
import '../models/transaction_status.dart';
import 'exceptions/repository_exceptions.dart';
import 'repayment_repository.dart';

class IsarRepaymentRepository implements RepaymentRepository {
  final Isar _isar;

  const IsarRepaymentRepository(this._isar);

  @override
  Future<void> addRepayment(Repayment repayment) async {
    try {
      repayment.validate();

      final transaction = await _isar.transactions.get(repayment.transactionId);
      if (transaction == null) {
        throw TransactionNotFoundException(repayment.transactionId);
      }

      await _isar.writeTxn(() async {
        await _isar.repayments.put(repayment);

        final totalRepaidAmount = await _calculateTotalRepaid(repayment.transactionId);
        final remainingBalance = transaction.amount - totalRepaidAmount;

        if (remainingBalance <= 0 && transaction.status != TransactionStatus.completed) {
          transaction.status = TransactionStatus.completed;
          transaction.updatedAt = DateTime.now();
          await _isar.transactions.put(transaction);

          developer.log('Transaction auto-completed: id=${transaction.id}', name: 'RepaymentRepository');
        }
      });

      developer.log('Repayment added: id=${repayment.id}, transactionId=${repayment.transactionId}, amount=${repayment.amount}', name: 'RepaymentRepository');
    } on TransactionNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log('Failed to add repayment', name: 'RepaymentRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw RepaymentRepositoryException('Failed to add repayment', e);
    }
  }

  Future<int> _calculateTotalRepaid(int transactionId) async {
    final repayments = await _isar.repayments.filter().transactionIdEqualTo(transactionId).findAll();
    return repayments.fold<int>(0, (sum, repayment) => sum + repayment.amount);
  }

  @override
  Future<List<Repayment>> getRepaymentsByTransactionId(int transactionId) async {
    try {
      final repayments = await _isar.repayments.filter().transactionIdEqualTo(transactionId).sortByWhen().findAll();

      developer.log('Retrieved ${repayments.length} repayments for transaction $transactionId', name: 'RepaymentRepository');

      return repayments;
    } catch (e, stackTrace) {
      developer.log('Failed to get repayments by transaction id', name: 'RepaymentRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw RepaymentRepositoryException('Failed to get repayments for transaction $transactionId', e);
    }
  }

  @override
  Future<void> deleteRepayment(int id) async {
    try {
      final deleted = await _isar.writeTxn(() async {
        return await _isar.repayments.delete(id);
      });

      if (!deleted) {
        throw RepaymentNotFoundException(id);
      }

      developer.log('Repayment deleted: id=$id', name: 'RepaymentRepository');
    } on RepaymentNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log('Failed to delete repayment', name: 'RepaymentRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw RepaymentRepositoryException('Failed to delete repayment', e);
    }
  }

  @override
  Future<double> totalRepaid(int transactionId) async {
    try {
      final repayments = await _isar.repayments.filter().transactionIdEqualTo(transactionId).findAll();

      final totalRepaidAmount = repayments.fold<int>(0, (sum, repayment) => sum + repayment.amount);

      final totalRepaidInMainUnit = totalRepaidAmount / 100.0;

      developer.log('Calculated total repaid for transaction $transactionId: $totalRepaidInMainUnit', name: 'RepaymentRepository');

      return totalRepaidInMainUnit;
    } catch (e, stackTrace) {
      developer.log('Failed to calculate total repaid', name: 'RepaymentRepository', level: 1000, error: e, stackTrace: stackTrace);
      throw RepaymentRepositoryException('Failed to calculate total repaid for transaction $transactionId', e);
    }
  }
}
