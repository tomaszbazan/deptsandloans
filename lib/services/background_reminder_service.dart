import 'dart:developer' as developer;
import 'package:deptsandloans/core/notifications/recurring_reminder_processor.dart';

class BackgroundReminderService {
  final RecurringReminderProcessor _processor;

  const BackgroundReminderService({required RecurringReminderProcessor processor}) : _processor = processor;

  Future<void> initialize() async {
    try {
      developer.log('Initializing background reminder service', name: 'BackgroundReminderService');
      await _processor.processActiveRecurringReminders();
      developer.log('Background reminder service initialized', name: 'BackgroundReminderService');
    } catch (e, stackTrace) {
      developer.log('Failed to initialize background reminder service', name: 'BackgroundReminderService', level: 1000, error: e, stackTrace: stackTrace);
    }
  }

  Future<void> onDeviceBootCompleted() async {
    try {
      developer.log('Device boot completed, rescheduling reminders', name: 'BackgroundReminderService');
      await _processor.processActiveRecurringReminders();
      developer.log('Reminders rescheduled after boot', name: 'BackgroundReminderService');
    } catch (e, stackTrace) {
      developer.log('Failed to reschedule reminders after boot', name: 'BackgroundReminderService', level: 1000, error: e, stackTrace: stackTrace);
    }
  }
}
