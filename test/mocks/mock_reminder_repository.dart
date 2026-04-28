import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/repositories/reminder_repository.dart';

class MockReminderRepository implements ReminderRepository {
  final List<Reminder> _reminders = [];
  int _nextId = 1;

  @override
  Future<void> createReminder(Reminder reminder) async {
    reminder.id = _nextId++;
    _reminders.add(reminder);
  }

  @override
  Future<List<Reminder>> getRemindersByTransactionId(int transactionId) async {
    return _reminders.where((r) => r.transactionId == transactionId).toList();
  }

  @override
  Future<List<Reminder>> getActiveReminders() async {
    return List.from(_reminders);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
    }
  }

  @override
  Future<void> updateNextReminderDate(int id, DateTime nextDate) async {
    final reminder = _reminders.firstWhere((r) => r.id == id);
    reminder.nextReminderDate = nextDate;
  }

  @override
  Future<void> deleteRemindersByTransactionId(int transactionId) async {
    _reminders.removeWhere((r) => r.transactionId == transactionId);
  }

  void clear() {
    _reminders.clear();
    _nextId = 1;
  }
}
