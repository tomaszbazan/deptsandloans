import 'package:deptsandloans/core/notifications/notification_service.dart';
import 'package:deptsandloans/core/notifications/notification_scheduler.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockNotificationScheduler extends NotificationScheduler {
  MockNotificationScheduler() : super(MockNotificationService());

  final List<int> cancelledNotificationIds = [];
  bool shouldThrowOnCancel = false;

  @override
  Future<int> scheduleOneTimeReminder({required Reminder reminder, required Transaction transaction, required String locale, required double remainingBalance}) async {
    return 1;
  }

  @override
  Future<void> cancelReminder(int notificationId) async {
    if (shouldThrowOnCancel) {
      throw Exception('Failed to cancel notification');
    }
    cancelledNotificationIds.add(notificationId);
  }

  void reset() {
    cancelledNotificationIds.clear();
    shouldThrowOnCancel = false;
  }
}
