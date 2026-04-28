import 'dart:io';

import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/repositories/exceptions/repository_exceptions.dart';
import 'package:deptsandloans/data/repositories/isar_repayment_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_notification_scheduler.dart';

void main() {
  late Isar isar;
  late IsarRepaymentRepository repository;
  late MockNotificationScheduler mockNotificationScheduler;
  final testDbDir = Directory('build/test_db');

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    if (!testDbDir.existsSync()) {
      testDbDir.createSync(recursive: true);
    }
  });

  setUp(() async {
    isar = await Isar.open([RepaymentSchema, TransactionSchema, ReminderSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');
    mockNotificationScheduler = MockNotificationScheduler();
    repository = IsarRepaymentRepository(isar, mockNotificationScheduler);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('RepaymentRepositoryImpl', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    Repayment createRepayment({int id = Isar.autoIncrement, int transactionId = 100, int amount = 5000, DateTime? when, DateTime? createdAt}) {
      return Repayment()
        ..id = id
        ..transactionId = transactionId
        ..amount = amount
        ..when = when ?? yesterday
        ..createdAt = createdAt ?? now;
    }

    group('addRepayment', () {
      test('throws RepaymentRepositoryException on validation error', () async {
        final repayment = createRepayment(amount: -100);

        expect(() => repository.addRepayment(repayment), throwsA(isA<RepaymentRepositoryException>().having((e) => e.message, 'message', 'Failed to add repayment')));
      });

      test('throws TransactionNotFoundException when transaction does not exist', () async {
        final repayment = createRepayment(transactionId: 999);

        expect(() => repository.addRepayment(repayment), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully adds a repayment when transaction exists', () async {
        final transaction = TransactionFixture.createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment = createRepayment(transactionId: transaction.id);
        await repository.addRepayment(repayment);

        final savedRepayment = await isar.repayments.get(repayment.id);
        expect(savedRepayment, isNotNull);
        expect(savedRepayment!.amount, equals(5000));
        expect(savedRepayment.transactionId, equals(transaction.id));
      });

      test('auto-completes transaction when balance reaches zero', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment = createRepayment(transactionId: transaction.id, amount: 10000);
        await repository.addRepayment(repayment);

        final updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction, isNotNull);
        expect(updatedTransaction!.isCompleted, isTrue);
      });

      test('cancels notifications when transaction is auto-completed', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = Reminder()
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..nextReminderDate = DateTime.now().add(const Duration(days: 1))
          ..notificationId = 123
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.reminders.put(reminder);
        });

        mockNotificationScheduler.reset();

        final repayment = createRepayment(transactionId: transaction.id, amount: 10000);
        await repository.addRepayment(repayment);

        final updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction!.isCompleted, isTrue);
        expect(mockNotificationScheduler.cancelledNotificationIds, contains(123));

        final remainingReminders = await isar.reminders.filter().transactionIdEqualTo(transaction.id).findAll();
        expect(remainingReminders, isEmpty);
      });

      test('continues auto-completion even if notification cancellation fails', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = Reminder()
          ..transactionId = transaction.id
          ..type = ReminderType.oneTime
          ..nextReminderDate = DateTime.now().add(const Duration(days: 1))
          ..notificationId = 456
          ..createdAt = DateTime.now();

        await isar.writeTxn(() async {
          await isar.reminders.put(reminder);
        });

        mockNotificationScheduler.shouldThrowOnCancel = true;

        final repayment = createRepayment(transactionId: transaction.id, amount: 10000);
        await repository.addRepayment(repayment);

        final updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction!.isCompleted, isTrue);
      });

      test('auto-completes transaction with multiple repayments when balance reaches zero', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment1 = createRepayment(transactionId: transaction.id, amount: 6000);
        await repository.addRepayment(repayment1);

        var updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction!.isActive, isTrue);

        final repayment2 = createRepayment(transactionId: transaction.id, amount: 4000);
        await repository.addRepayment(repayment2);

        updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction!.isCompleted, isTrue);
      });

      test('does not complete transaction when balance is above zero', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment = createRepayment(transactionId: transaction.id, amount: 5000);
        await repository.addRepayment(repayment);

        final updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction, isNotNull);
        expect(updatedTransaction!.isActive, isTrue);
      });

      test('does not update transaction status if already completed', () async {
        final transaction = TransactionFixture.createTransaction(amount: 10000, status: TransactionStatus.completed);
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final originalUpdatedAt = transaction.updatedAt;

        final repayment = createRepayment(transactionId: transaction.id, amount: 5000);
        await repository.addRepayment(repayment);

        final updatedTransaction = await isar.transactions.get(transaction.id);
        expect(updatedTransaction, isNotNull);
        expect(updatedTransaction!.isCompleted, isTrue);
        expect(updatedTransaction.updatedAt, equals(originalUpdatedAt));
      });
    });

    group('getRepaymentsByTransactionId', () {
      test('returns empty list when no repayments exist', () async {
        final repayments = await repository.getRepaymentsByTransactionId(100);

        expect(repayments, isEmpty);
      });

      test('returns repayments sorted by when date', () async {
        final transaction = TransactionFixture.createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment1 = createRepayment(transactionId: transaction.id, when: yesterday);
        final repayment2 = createRepayment(transactionId: transaction.id, when: yesterday.subtract(const Duration(days: 1)));
        final repayment3 = createRepayment(transactionId: transaction.id, when: yesterday.add(const Duration(hours: 1)));

        await repository.addRepayment(repayment1);
        await repository.addRepayment(repayment2);
        await repository.addRepayment(repayment3);

        final repayments = await repository.getRepaymentsByTransactionId(transaction.id);

        expect(repayments, hasLength(3));
        expect(repayments[0].when, equals(repayment2.when));
        expect(repayments[1].when, equals(repayment1.when));
        expect(repayments[2].when, equals(repayment3.when));
      });

      test('returns only repayments for specified transaction', () async {
        final transaction1 = TransactionFixture.createTransaction(id: 100);
        final transaction2 = TransactionFixture.createTransaction(id: 200);

        await isar.writeTxn(() async {
          await isar.transactions.put(transaction1);
          await isar.transactions.put(transaction2);
        });

        final repayment1 = createRepayment(transactionId: transaction1.id);
        final repayment2 = createRepayment(transactionId: transaction2.id);

        await repository.addRepayment(repayment1);
        await repository.addRepayment(repayment2);

        final repayments = await repository.getRepaymentsByTransactionId(transaction1.id);

        expect(repayments, hasLength(1));
        expect(repayments[0].transactionId, equals(transaction1.id));
      });
    });

    group('deleteRepayment', () {
      test('successfully deletes a repayment when it exists', () async {
        final transaction = TransactionFixture.createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment = createRepayment(transactionId: transaction.id);
        await repository.addRepayment(repayment);

        await repository.deleteRepayment(repayment.id);

        final deletedRepayment = await isar.repayments.get(repayment.id);
        expect(deletedRepayment, isNull);
      });

      test('throws RepaymentNotFoundException when repayment does not exist', () async {
        expect(() => repository.deleteRepayment(999), throwsA(isA<RepaymentNotFoundException>().having((e) => e.id, 'id', 999)));
      });
    });

    group('totalRepaid', () {
      test('returns zero when no repayments exist', () async {
        final total = await repository.totalRepaid(100);

        expect(total, equals(0.0));
      });

      test('calculates total repaid with single repayment', () async {
        final transaction = TransactionFixture.createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment = createRepayment(transactionId: transaction.id, amount: 3000);
        await repository.addRepayment(repayment);

        final total = await repository.totalRepaid(transaction.id);

        expect(total, equals(30.0));
      });

      test('calculates total repaid with multiple repayments', () async {
        final transaction = TransactionFixture.createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final repayment1 = createRepayment(transactionId: transaction.id, amount: 3000);
        final repayment2 = createRepayment(transactionId: transaction.id, amount: 2000);
        final repayment3 = createRepayment(transactionId: transaction.id, amount: 1500);

        await repository.addRepayment(repayment1);
        await repository.addRepayment(repayment2);
        await repository.addRepayment(repayment3);

        final total = await repository.totalRepaid(transaction.id);

        expect(total, equals(65.0));
      });

      test('returns only total for specified transaction', () async {
        final transaction1 = TransactionFixture.createTransaction(id: 100);
        final transaction2 = TransactionFixture.createTransaction(id: 200);

        await isar.writeTxn(() async {
          await isar.transactions.put(transaction1);
          await isar.transactions.put(transaction2);
        });

        final repayment1 = createRepayment(transactionId: transaction1.id, amount: 3000);
        final repayment2 = createRepayment(transactionId: transaction2.id, amount: 5000);

        await repository.addRepayment(repayment1);
        await repository.addRepayment(repayment2);

        final total = await repository.totalRepaid(transaction1.id);

        expect(total, equals(30.0));
      });
    });
  });
}
