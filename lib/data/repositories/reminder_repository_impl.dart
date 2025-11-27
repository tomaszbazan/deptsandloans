import 'dart:developer' as developer;
import 'package:isar_community/isar.dart';
import '../models/reminder.dart';
import '../models/transaction.dart';
import 'exceptions/repository_exceptions.dart';
import 'reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final Isar _isar;

  const ReminderRepositoryImpl(this._isar);

  @override
  Future<void> createReminder(Reminder reminder) async {
    try {
      final transactionExists = await _isar.transactions
          .get(reminder.transactionId);
      if (transactionExists == null) {
        throw TransactionNotFoundException(reminder.transactionId);
      }

      reminder.validate();

      await _isar.writeTxn(() async {
        await _isar.reminders.put(reminder);
      });

      developer.log(
        'Reminder created: id=${reminder.id}, transactionId=${reminder.transactionId}, type=${reminder.type}',
        name: 'ReminderRepository',
      );
    } on TransactionNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to create reminder',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException('Failed to create reminder', e);
    }
  }

  @override
  Future<List<Reminder>> getRemindersByTransactionId(
    int transactionId,
  ) async {
    try {
      final reminders = await _isar.reminders
          .filter()
          .transactionIdEqualTo(transactionId)
          .sortByCreatedAt()
          .findAll();

      developer.log(
        'Retrieved ${reminders.length} reminders for transaction $transactionId',
        name: 'ReminderRepository',
      );

      return reminders;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to get reminders by transaction id',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException(
        'Failed to get reminders for transaction $transactionId',
        e,
      );
    }
  }

  @override
  Future<List<Reminder>> getActiveReminders() async {
    try {
      final now = DateTime.now();
      final reminders = await _isar.reminders
          .filter()
          .nextReminderDateLessThan(now, include: true)
          .findAll();

      developer.log(
        'Retrieved ${reminders.length} active reminders',
        name: 'ReminderRepository',
      );

      return reminders;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to get active reminders',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException('Failed to get active reminders', e);
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      final existing = await _isar.reminders.get(reminder.id);
      if (existing == null) {
        throw ReminderNotFoundException(reminder.id);
      }

      reminder.validate();

      await _isar.writeTxn(() async {
        await _isar.reminders.put(reminder);
      });

      developer.log(
        'Reminder updated: id=${reminder.id}, transactionId=${reminder.transactionId}',
        name: 'ReminderRepository',
      );
    } on ReminderNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update reminder',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException('Failed to update reminder', e);
    }
  }

  @override
  Future<void> updateNextReminderDate(int id, DateTime nextDate) async {
    try {
      final reminder = await _isar.reminders.get(id);
      if (reminder == null) {
        throw ReminderNotFoundException(id);
      }

      reminder.nextReminderDate = nextDate;

      await _isar.writeTxn(() async {
        await _isar.reminders.put(reminder);
      });

      developer.log(
        'Next reminder date updated: id=$id, nextDate=$nextDate',
        name: 'ReminderRepository',
      );
    } on ReminderNotFoundException {
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update next reminder date',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException(
        'Failed to update next reminder date',
        e,
      );
    }
  }

  @override
  Future<void> deleteRemindersByTransactionId(int transactionId) async {
    try {
      final deletedCount = await _isar.writeTxn(() async {
        return await _isar.reminders
            .filter()
            .transactionIdEqualTo(transactionId)
            .deleteAll();
      });

      developer.log(
        'Deleted $deletedCount reminders for transaction $transactionId',
        name: 'ReminderRepository',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to delete reminders by transaction id',
        name: 'ReminderRepository',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      throw ReminderRepositoryException(
        'Failed to delete reminders for transaction $transactionId',
        e,
      );
    }
  }
}
