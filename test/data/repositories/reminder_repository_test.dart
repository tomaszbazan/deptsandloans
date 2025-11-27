import 'dart:io';

import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/exceptions/repository_exceptions.dart';
import 'package:deptsandloans/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Isar isar;
  late ReminderRepositoryImpl repository;
  final testDbDir = Directory('build/test_db');

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    if (!testDbDir.existsSync()) {
      testDbDir.createSync(recursive: true);
    }
  });

  setUp(() async {
    isar = await Isar.open([ReminderSchema, TransactionSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');
    repository = ReminderRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('ReminderRepositoryImpl', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final yesterday = now.subtract(const Duration(days: 1));

    Reminder createReminder({
      int id = Isar.autoIncrement,
      int transactionId = 100,
      ReminderType type = ReminderType.oneTime,
      int? intervalDays,
      DateTime? nextReminderDate,
      DateTime? createdAt,
    }) {
      return Reminder()
        ..id = id
        ..transactionId = transactionId
        ..type = type
        ..intervalDays = intervalDays
        ..nextReminderDate = nextReminderDate ?? tomorrow
        ..createdAt = createdAt ?? now;
    }

    Transaction createTransaction({int id = Isar.autoIncrement}) {
      return Transaction()
        ..id = id
        ..type = TransactionType.debt
        ..name = 'Test Transaction'
        ..amount = 10000
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;
    }

    group('createReminder', () {
      test('throws ReminderRepositoryException on validation error', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, type: ReminderType.recurring, intervalDays: null);

        expect(() => repository.createReminder(reminder), throwsA(isA<ReminderRepositoryException>().having((e) => e.message, 'message', 'Failed to create reminder')));
      });

      test('throws TransactionNotFoundException when transaction does not exist', () async {
        final reminder = createReminder(transactionId: 999);

        expect(() => repository.createReminder(reminder), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully creates a one-time reminder', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, type: ReminderType.oneTime);
        await repository.createReminder(reminder);

        final savedReminder = await isar.reminders.get(reminder.id);
        expect(savedReminder, isNotNull);
        expect(savedReminder!.type, equals(ReminderType.oneTime));
        expect(savedReminder.transactionId, equals(transaction.id));
        expect(savedReminder.intervalDays, isNull);
      });

      test('successfully creates a recurring reminder', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, type: ReminderType.recurring, intervalDays: 7);
        await repository.createReminder(reminder);

        final savedReminder = await isar.reminders.get(reminder.id);
        expect(savedReminder, isNotNull);
        expect(savedReminder!.type, equals(ReminderType.recurring));
        expect(savedReminder.intervalDays, equals(7));
      });
    });

    group('getRemindersByTransactionId', () {
      test('returns empty list when no reminders exist', () async {
        final reminders = await repository.getRemindersByTransactionId(100);

        expect(reminders, isEmpty);
      });

      test('returns reminders sorted by creation date', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder1 = createReminder(transactionId: transaction.id, createdAt: now);
        final reminder2 = createReminder(transactionId: transaction.id, createdAt: yesterday);
        final reminder3 = createReminder(transactionId: transaction.id, createdAt: tomorrow);

        await repository.createReminder(reminder1);
        await repository.createReminder(reminder2);
        await repository.createReminder(reminder3);

        final reminders = await repository.getRemindersByTransactionId(transaction.id);

        expect(reminders, hasLength(3));
        expect(reminders[0].createdAt, equals(reminder2.createdAt));
        expect(reminders[1].createdAt, equals(reminder1.createdAt));
        expect(reminders[2].createdAt, equals(reminder3.createdAt));
      });

      test('returns only reminders for specified transaction', () async {
        final transaction1 = createTransaction(id: 100);
        final transaction2 = createTransaction(id: 200);

        await isar.writeTxn(() async {
          await isar.transactions.put(transaction1);
          await isar.transactions.put(transaction2);
        });

        final reminder1 = createReminder(transactionId: transaction1.id);
        final reminder2 = createReminder(transactionId: transaction2.id);

        await repository.createReminder(reminder1);
        await repository.createReminder(reminder2);

        final reminders = await repository.getRemindersByTransactionId(transaction1.id);

        expect(reminders, hasLength(1));
        expect(reminders[0].transactionId, equals(transaction1.id));
      });
    });

    group('getActiveReminders', () {
      test('returns empty list when no active reminders exist', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, nextReminderDate: tomorrow);
        await repository.createReminder(reminder);

        final activeReminders = await repository.getActiveReminders();

        expect(activeReminders, isEmpty);
      });

      test('returns reminders with nextReminderDate in the past', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder1 = createReminder(transactionId: transaction.id, nextReminderDate: yesterday);
        final reminder2 = createReminder(transactionId: transaction.id, nextReminderDate: tomorrow);

        await repository.createReminder(reminder1);
        await repository.createReminder(reminder2);

        final activeReminders = await repository.getActiveReminders();

        expect(activeReminders, hasLength(1));
        expect(activeReminders[0].id, equals(reminder1.id));
      });

      test('returns reminders with nextReminderDate equal to now', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, nextReminderDate: now);
        await repository.createReminder(reminder);

        final activeReminders = await repository.getActiveReminders();

        expect(activeReminders, hasLength(1));
        expect(activeReminders[0].id, equals(reminder.id));
      });
    });

    group('updateReminder', () {
      test('throws ReminderNotFoundException when reminder does not exist', () async {
        final reminder = createReminder(id: 999);

        expect(() => repository.updateReminder(reminder), throwsA(isA<ReminderNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully updates an existing reminder', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, type: ReminderType.oneTime);
        await repository.createReminder(reminder);

        reminder.type = ReminderType.recurring;
        reminder.intervalDays = 14;
        await repository.updateReminder(reminder);

        final updatedReminder = await isar.reminders.get(reminder.id);
        expect(updatedReminder, isNotNull);
        expect(updatedReminder!.type, equals(ReminderType.recurring));
        expect(updatedReminder.intervalDays, equals(14));
      });
    });

    group('updateNextReminderDate', () {
      test('throws ReminderNotFoundException when reminder does not exist', () async {
        expect(() => repository.updateNextReminderDate(999, tomorrow), throwsA(isA<ReminderNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully updates next reminder date', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder = createReminder(transactionId: transaction.id, nextReminderDate: now);
        await repository.createReminder(reminder);

        final newDate = now.add(const Duration(days: 7));
        await repository.updateNextReminderDate(reminder.id, newDate);

        final updatedReminder = await isar.reminders.get(reminder.id);
        expect(updatedReminder, isNotNull);
        expect(updatedReminder!.nextReminderDate, equals(newDate));
      });
    });

    group('deleteRemindersByTransactionId', () {
      test('successfully deletes all reminders for a transaction', () async {
        final transaction = createTransaction();
        await isar.writeTxn(() async {
          await isar.transactions.put(transaction);
        });

        final reminder1 = createReminder(transactionId: transaction.id);
        final reminder2 = createReminder(transactionId: transaction.id);

        await repository.createReminder(reminder1);
        await repository.createReminder(reminder2);

        await repository.deleteRemindersByTransactionId(transaction.id);

        final reminders = await repository.getRemindersByTransactionId(transaction.id);
        expect(reminders, isEmpty);
      });

      test('does not delete reminders for other transactions', () async {
        final transaction1 = createTransaction(id: 100);
        final transaction2 = createTransaction(id: 200);

        await isar.writeTxn(() async {
          await isar.transactions.put(transaction1);
          await isar.transactions.put(transaction2);
        });

        final reminder1 = createReminder(transactionId: transaction1.id);
        final reminder2 = createReminder(transactionId: transaction2.id);

        await repository.createReminder(reminder1);
        await repository.createReminder(reminder2);

        await repository.deleteRemindersByTransactionId(transaction1.id);

        final reminders1 = await repository.getRemindersByTransactionId(transaction1.id);
        final reminders2 = await repository.getRemindersByTransactionId(transaction2.id);

        expect(reminders1, isEmpty);
        expect(reminders2, hasLength(1));
      });

      test('does nothing when no reminders exist for transaction', () async {
        await repository.deleteRemindersByTransactionId(999);

        final reminders = await repository.getRemindersByTransactionId(999);
        expect(reminders, isEmpty);
      });
    });
  });
}
