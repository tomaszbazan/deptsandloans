import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/repositories/reminder_repository.dart';

class MockReminderRepository implements ReminderRepository {
  @override
  Future<void> createReminder(Reminder reminder) async {}

  @override
  Future<List<Reminder>> getRemindersByTransactionId(int transactionId) async {
    return [];
  }

  @override
  Future<List<Reminder>> getActiveReminders() async {
    return [];
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {}

  @override
  Future<void> updateNextReminderDate(int id, DateTime nextDate) async {}

  @override
  Future<void> deleteRemindersByTransactionId(int transactionId) async {}
}
