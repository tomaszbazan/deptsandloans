import '../models/reminder.dart';

abstract class ReminderRepository {
  Future<void> createReminder(Reminder reminder);

  Future<List<Reminder>> getRemindersByTransactionId(int transactionId);

  Future<List<Reminder>> getActiveReminders();

  Future<void> updateReminder(Reminder reminder);

  Future<void> updateNextReminderDate(int id, DateTime nextDate);

  Future<void> deleteRemindersByTransactionId(int transactionId);
}
