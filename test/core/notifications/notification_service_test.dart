import 'package:deptsandloans/core/notifications/notification_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationConstants', () {
    test('notification constants have expected values', () {
      expect(NotificationConstants.channelId, 'debt_loan_reminders');
      expect(NotificationConstants.defaultNotificationHour, 19);
      expect(NotificationConstants.defaultNotificationMinute, 0);
      expect(NotificationConstants.channelName, 'Debt and Loan Reminders');
      expect(NotificationConstants.channelDescription, 'Notifications for debt and loan payment reminders');
    });
  });
}
