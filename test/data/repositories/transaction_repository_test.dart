import 'dart:io';

import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/exceptions/repository_exceptions.dart';
import 'package:deptsandloans/data/repositories/isar_repayment_repository.dart';
import 'package:deptsandloans/data/repositories/isar_transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_notification_scheduler.dart';

void main() {
  late Isar isar;
  late IsarTransactionRepository repository;
  late IsarRepaymentRepository repaymentRepository;
  late MockNotificationScheduler mockNotificationScheduler;
  final testDbDir = Directory('build/test_db');

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    if (!testDbDir.existsSync()) {
      testDbDir.createSync(recursive: true);
    }
  });

  setUp(() async {
    isar = await Isar.open([TransactionSchema, RepaymentSchema, ReminderSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');
    mockNotificationScheduler = MockNotificationScheduler();
    repository = IsarTransactionRepository(isar, mockNotificationScheduler);
    repaymentRepository = IsarRepaymentRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('TransactionRepositoryImpl', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    group('create', () {
      test('throws TransactionRepositoryException on validation error', () async {
        final transaction = TransactionFixture.createTransaction(name: '');

        expect(() => repository.create(transaction), throwsA(isA<TransactionRepositoryException>().having((e) => e.message, 'message', 'Failed to create transaction')));
      });

      test('successfully creates a transaction', () async {
        final transaction = TransactionFixture.createTransaction(dueDate: tomorrow);

        await repository.create(transaction);

        final savedTransaction = await isar.transactions.get(transaction.id);
        expect(savedTransaction, isNotNull);
        expect(savedTransaction!.name, equals('John Doe'));
        expect(savedTransaction.amount, equals(10000));
        expect(savedTransaction.type, equals(TransactionType.debt));
      });
    });

    group('getById', () {
      test('returns null when transaction not found', () async {
        final transaction = await repository.getById(999);

        expect(transaction, isNull);
      });

      test('successfully returns transaction when it exists', () async {
        final transaction = TransactionFixture.createTransaction(name: 'Test Transaction');
        await repository.create(transaction);

        final retrieved = await repository.getById(transaction.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(transaction.id));
        expect(retrieved.name, equals('Test Transaction'));
        expect(retrieved.amount, equals(10000));
      });
    });

    group('getByType', () {
      test('returns empty list when no transactions exist', () async {
        final transactions = await repository.getByType(TransactionType.debt);

        expect(transactions, isEmpty);
      });

      test('returns only transactions of specified type', () async {
        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Debt 1');
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Debt 2');
        final loan = TransactionFixture.createTransaction(type: TransactionType.loan, name: 'Loan 1');

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(loan);

        final debts = await repository.getByType(TransactionType.debt);
        final loans = await repository.getByType(TransactionType.loan);

        expect(debts, hasLength(2));
        expect(debts.every((t) => t.type == TransactionType.debt), isTrue);
        expect(loans, hasLength(1));
        expect(loans.first.type, equals(TransactionType.loan));
      });

      test('sorts transactions by due date in ascending order', () async {
        final inThreeDays = now.add(const Duration(days: 3));
        final inFiveDays = now.add(const Duration(days: 5));

        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due in 5 days', dueDate: inFiveDays);
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due tomorrow', dueDate: tomorrow);
        final debt3 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due in 3 days', dueDate: inThreeDays);

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(debt3);

        final debts = await repository.getByType(TransactionType.debt);

        expect(debts, hasLength(3));
        expect(debts[0].name, equals('Due tomorrow'));
        expect(debts[1].name, equals('Due in 3 days'));
        expect(debts[2].name, equals('Due in 5 days'));
      });

      test('places transactions without due date at the bottom', () async {
        final inThreeDays = now.add(const Duration(days: 3));

        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'No due date 1', dueDate: null);
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due in 3 days', dueDate: inThreeDays);
        final debt3 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due tomorrow', dueDate: tomorrow);
        final debt4 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'No due date 2', dueDate: null);

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(debt3);
        await repository.create(debt4);

        final debts = await repository.getByType(TransactionType.debt);

        expect(debts, hasLength(4));
        expect(debts[0].name, equals('Due tomorrow'));
        expect(debts[1].name, equals('Due in 3 days'));
        expect(debts[2].dueDate, isNull);
        expect(debts[3].dueDate, isNull);
      });

      test('handles all transactions without due dates', () async {
        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Debt 1', dueDate: null);
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Debt 2', dueDate: null);
        final debt3 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Debt 3', dueDate: null);

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(debt3);

        final debts = await repository.getByType(TransactionType.debt);

        expect(debts, hasLength(3));
        expect(debts.every((t) => t.dueDate == null), isTrue);
      });

      test('handles transactions with same due date', () async {
        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Same date 1', dueDate: tomorrow);
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Same date 2', dueDate: tomorrow);

        await repository.create(debt1);
        await repository.create(debt2);

        final debts = await repository.getByType(TransactionType.debt);

        expect(debts, hasLength(2));
        expect(debts.every((t) => t.dueDate == tomorrow), isTrue);
      });

      test('sorts multiple future due dates correctly', () async {
        final inTwoDays = now.add(const Duration(days: 2));
        final inFourDays = now.add(const Duration(days: 4));

        final debt1 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due in 4 days', dueDate: inFourDays);
        final debt2 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due in 2 days', dueDate: inTwoDays);
        final debt3 = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Due tomorrow', dueDate: tomorrow);

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(debt3);

        final debts = await repository.getByType(TransactionType.debt);

        expect(debts, hasLength(3));
        expect(debts[0].name, equals('Due tomorrow'));
        expect(debts[1].name, equals('Due in 2 days'));
        expect(debts[2].name, equals('Due in 4 days'));
      });
    });

    group('update', () {
      test('throws TransactionNotFoundException when transaction not found', () async {
        final transaction = TransactionFixture.createTransaction(id: 999);

        expect(() => repository.update(transaction), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('throws TransactionRepositoryException on validation error', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        final invalidTransaction = TransactionFixture.createTransaction(id: transaction.id, name: '');

        expect(() => repository.update(invalidTransaction), throwsA(isA<TransactionRepositoryException>().having((e) => e.message, 'message', 'Failed to update transaction')));
      });

      test('successfully updates a transaction', () async {
        final transaction = TransactionFixture.createTransaction(name: 'Original Name');
        await repository.create(transaction);

        final updatedTransaction = TransactionFixture.createTransaction(id: transaction.id, name: 'Updated Name', amount: 20000);

        await repository.update(updatedTransaction);

        final savedTransaction = await isar.transactions.get(transaction.id);
        expect(savedTransaction, isNotNull);
        expect(savedTransaction!.name, equals('Updated Name'));
        expect(savedTransaction.amount, equals(20000));
      });
    });

    group('delete', () {
      test('throws TransactionNotFoundException when transaction not found', () async {
        expect(() => repository.delete(999), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully deletes a transaction', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        await repository.delete(transaction.id);

        final deletedTransaction = await isar.transactions.get(transaction.id);
        expect(deletedTransaction, isNull);
      });

      test('cascades deletion to associated repayments', () async {
        final transaction1 = TransactionFixture.createTransaction();
        await repository.create(transaction1);
        final transaction2 = TransactionFixture.createTransaction();
        await repository.create(transaction2);

        final repayment1 = Repayment()
          ..id = 1
          ..transactionId = transaction1.id
          ..amount = 5000
          ..when = DateTime.now()
          ..createdAt = DateTime.now();

        final repayment2 = Repayment()
          ..id = 2
          ..transactionId = transaction1.id
          ..amount = 3000
          ..when = DateTime.now()
          ..createdAt = DateTime.now();

        final repayment3 = Repayment()
          ..id = 3
          ..transactionId = transaction2.id
          ..amount = 3000
          ..when = DateTime.now()
          ..createdAt = DateTime.now();
        await repaymentRepository.addRepayment(repayment1);
        await repaymentRepository.addRepayment(repayment2);
        await repaymentRepository.addRepayment(repayment3);

        final repaymentsBeforeDelete = await repaymentRepository.getRepaymentsByTransactionId(transaction1.id);
        expect(repaymentsBeforeDelete.length, equals(2));

        await repository.delete(transaction1.id);

        final deletedTransaction = await repository.getById(transaction1.id);
        expect(deletedTransaction, isNull);

        final repaymentsAfterDelete = await repaymentRepository.getRepaymentsByTransactionId(transaction1.id);
        expect(repaymentsAfterDelete.length, equals(0));

        final otherTransaction = await repository.getById(transaction2.id);
        expect(otherTransaction, isNotNull);
        expect(otherTransaction!.id, equals(transaction2.id));

        final otherRepaymentsAfterDelete = await repaymentRepository.getRepaymentsByTransactionId(transaction2.id);
        expect(otherRepaymentsAfterDelete.length, equals(1));
      });
    });

    group('markAsCompleted', () {
      test('throws TransactionNotFoundException when transaction not found', () async {
        expect(() => repository.markAsCompleted(999), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully marks active transaction as completed', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        expect(transaction.isActive, isTrue);
        expect(transaction.isCompleted, isFalse);

        await repository.markAsCompleted(transaction.id);

        final completedTransaction = await isar.transactions.get(transaction.id);
        expect(completedTransaction, isNotNull);
        expect(completedTransaction!.isCompleted, isTrue);
        expect(completedTransaction.isActive, isFalse);
      });

      test('updates updatedAt timestamp when marking as completed', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        final originalUpdatedAt = transaction.updatedAt;
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await repository.markAsCompleted(transaction.id);

        final completedTransaction = await isar.transactions.get(transaction.id);
        expect(completedTransaction, isNotNull);
        expect(completedTransaction!.updatedAt.isAfter(originalUpdatedAt), isTrue);
      });

      test('does not throw error when marking already completed transaction', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        await repository.markAsCompleted(transaction.id);
        await repository.markAsCompleted(transaction.id);

        final completedTransaction = await isar.transactions.get(transaction.id);
        expect(completedTransaction, isNotNull);
        expect(completedTransaction!.isCompleted, isTrue);
      });

      test('cancels notifications for all reminders when marking transaction as completed', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        final reminder1 = Reminder()
          ..id = 1
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..notificationId = 101
          ..nextReminderDate = DateTime.now().add(const Duration(days: 1))
          ..createdAt = DateTime.now();

        final reminder2 = Reminder()
          ..id = 2
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..notificationId = 102
          ..nextReminderDate = DateTime.now().add(const Duration(days: 2))
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.reminders.put(reminder1);
          await isar.reminders.put(reminder2);
        });

        mockNotificationScheduler.reset();

        await repository.markAsCompleted(transaction.id);

        expect(mockNotificationScheduler.cancelledNotificationIds, hasLength(2));
        expect(mockNotificationScheduler.cancelledNotificationIds, contains(101));
        expect(mockNotificationScheduler.cancelledNotificationIds, contains(102));
      });

      test('does not cancel notifications for reminders without notification IDs', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        final reminder1 = Reminder()
          ..id = 1
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..notificationId = 101
          ..nextReminderDate = DateTime.now().add(const Duration(days: 1))
          ..createdAt = DateTime.now();

        final reminder2 = Reminder()
          ..id = 2
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..notificationId = null
          ..nextReminderDate = DateTime.now().add(const Duration(days: 2))
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.reminders.put(reminder1);
          await isar.reminders.put(reminder2);
        });

        mockNotificationScheduler.reset();

        await repository.markAsCompleted(transaction.id);

        expect(mockNotificationScheduler.cancelledNotificationIds, hasLength(1));
        expect(mockNotificationScheduler.cancelledNotificationIds, contains(101));
      });

      test('continues to mark transaction as completed even if notification cancellation fails', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        final reminder = Reminder()
          ..id = 1
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..notificationId = 101
          ..nextReminderDate = DateTime.now().add(const Duration(days: 1))
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.reminders.put(reminder);
        });

        mockNotificationScheduler.shouldThrowOnCancel = true;

        await repository.markAsCompleted(transaction.id);

        final completedTransaction = await isar.transactions.get(transaction.id);
        expect(completedTransaction, isNotNull);
        expect(completedTransaction!.isCompleted, isTrue);
      });

      test('does not cancel notifications when there are no reminders', () async {
        final transaction = TransactionFixture.createTransaction();
        await repository.create(transaction);

        mockNotificationScheduler.reset();

        await repository.markAsCompleted(transaction.id);

        expect(mockNotificationScheduler.cancelledNotificationIds, isEmpty);

        final completedTransaction = await isar.transactions.get(transaction.id);
        expect(completedTransaction, isNotNull);
        expect(completedTransaction!.isCompleted, isTrue);
      });
    });
  });
}
