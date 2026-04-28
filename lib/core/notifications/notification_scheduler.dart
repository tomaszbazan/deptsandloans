import 'dart:developer' as developer;
import 'package:deptsandloans/core/notifications/notification_content_formatter.dart';
import 'package:deptsandloans/core/notifications/notification_service.dart';
import 'package:deptsandloans/core/notifications/models/notification_payload.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/transaction.dart';

class NotificationScheduler {
  final NotificationService _notificationService;

  const NotificationScheduler(this._notificationService);

  Future<int> scheduleOneTimeReminder({required Reminder reminder, required Transaction transaction, required String locale, required double remainingBalance}) async {
    try {
      final scheduledDateTime = _calculateScheduledDateTime(reminder.nextReminderDate);

      if (scheduledDateTime.isBefore(DateTime.now())) {
        throw ArgumentError('Cannot schedule reminder in the past');
      }

      final notificationId = _generateNotificationId(reminder, transaction);

      final title = NotificationContentFormatter.formatTitle(locale, transaction.type.name);

      final body = NotificationContentFormatter.formatBody(locale, transaction.name, remainingBalance, transaction.currency.symbol, transaction.type.name);

      final payload = NotificationPayload(
        transactionId: transaction.id.toString(),
        transactionType: transaction.type.name,
        transactionName: transaction.name,
        remainingAmount: remainingBalance,
        currency: transaction.currency.symbol,
      );

      await _notificationService.scheduleNotification(id: notificationId, title: title, body: body, scheduledDate: scheduledDateTime, payload: payload);

      developer.log('One-time reminder scheduled: id=$notificationId, date=$scheduledDateTime', name: 'NotificationScheduler');

      return notificationId;
    } catch (e, stackTrace) {
      developer.log('Failed to schedule one-time reminder', name: 'NotificationScheduler', level: 1000, error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<int> scheduleRecurringReminder({required Reminder reminder, required Transaction transaction, required String locale, required double remainingBalance}) async {
    try {
      final scheduledDateTime = _calculateScheduledDateTime(reminder.nextReminderDate);

      if (scheduledDateTime.isBefore(DateTime.now())) {
        throw ArgumentError('Cannot schedule reminder in the past');
      }

      final notificationId = _generateNotificationId(reminder, transaction);

      final title = NotificationContentFormatter.formatTitle(locale, transaction.type.name);

      final body = NotificationContentFormatter.formatBody(locale, transaction.name, remainingBalance, transaction.currency.symbol, transaction.type.name);

      final payload = NotificationPayload(
        transactionId: transaction.id.toString(),
        transactionType: transaction.type.name,
        transactionName: transaction.name,
        remainingAmount: remainingBalance,
        currency: transaction.currency.symbol,
      );

      await _notificationService.scheduleNotification(id: notificationId, title: title, body: body, scheduledDate: scheduledDateTime, payload: payload);

      developer.log('Recurring reminder scheduled: id=$notificationId, date=$scheduledDateTime', name: 'NotificationScheduler');

      return notificationId;
    } catch (e, stackTrace) {
      developer.log('Failed to schedule recurring reminder', name: 'NotificationScheduler', level: 1000, error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> cancelReminder(int notificationId) async {
    try {
      await _notificationService.cancelNotification(notificationId);
      developer.log('Reminder cancelled: id=$notificationId', name: 'NotificationScheduler');
    } catch (e, stackTrace) {
      developer.log('Failed to cancel reminder', name: 'NotificationScheduler', level: 1000, error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  DateTime _calculateScheduledDateTime(DateTime targetDate) {
    final scheduledTime = DateTime(targetDate.year, targetDate.month, targetDate.day, 19, 0, 0);

    return scheduledTime;
  }

  int _generateNotificationId(Reminder reminder, Transaction transaction) {
    return reminder.id * 1000 + transaction.id;
  }
}
