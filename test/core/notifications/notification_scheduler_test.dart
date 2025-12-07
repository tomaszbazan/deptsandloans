import 'package:deptsandloans/core/notifications/notification_scheduler.dart';
import 'package:deptsandloans/core/notifications/notification_service.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockNotificationService mockNotificationService;
  late NotificationScheduler scheduler;

  setUp(() {
    mockNotificationService = MockNotificationService();
    scheduler = NotificationScheduler(mockNotificationService);
  });

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  group('NotificationScheduler', () {
    group('scheduleOneTimeReminder', () {
      test('should schedule notification at 19:00 on target date', () async {
        final reminderDate = DateTime(2025, 12, 15);
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.oneTime
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) async => {});

        final notificationId = await scheduler.scheduleOneTimeReminder(reminder: reminder, transaction: transaction, locale: 'en', remainingBalance: 100.00);

        expect(notificationId, equals(1042));

        final captured = verify(
          () => mockNotificationService.scheduleNotification(
            id: captureAny(named: 'id'),
            title: captureAny(named: 'title'),
            body: captureAny(named: 'body'),
            scheduledDate: captureAny(named: 'scheduledDate'),
            payload: captureAny(named: 'payload'),
          ),
        ).captured;

        expect(captured[0], equals(1042));
        expect(captured[1], contains('Reminder'));
        expect(captured[2], contains('Test Debt'));
        expect(captured[3], equals(DateTime(2025, 12, 15, 19, 0, 0)));
      });

      test('should throw error when scheduling in the past', () async {
        final reminderDate = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.oneTime
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        expect(() => scheduler.scheduleOneTimeReminder(reminder: reminder, transaction: transaction, locale: 'en', remainingBalance: 100.00), throwsA(isA<ArgumentError>()));
      });

      test('should format notification for Polish locale', () async {
        final reminderDate = DateTime(2025, 12, 15);
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.oneTime
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) async => {});

        await scheduler.scheduleOneTimeReminder(reminder: reminder, transaction: transaction, locale: 'pl', remainingBalance: 100.00);

        final captured = verify(
          () => mockNotificationService.scheduleNotification(
            id: captureAny(named: 'id'),
            title: captureAny(named: 'title'),
            body: captureAny(named: 'body'),
            scheduledDate: captureAny(named: 'scheduledDate'),
            payload: captureAny(named: 'payload'),
          ),
        ).captured;

        expect(captured[1], contains('Przypomnienie'));
        expect(captured[2], contains('Zwróć'));
      });
    });

    group('scheduleRecurringReminder', () {
      test('should schedule notification at 19:00 on nextReminderDate', () async {
        final reminderDate = DateTime(2025, 12, 15);
        final reminder = Reminder()
          ..id = 2
          ..transactionId = 43
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 43
          ..type = TransactionType.loan
          ..name = 'Test Loan'
          ..amount = 20000
          ..currency = Currency.usd
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) async => {});

        final notificationId = await scheduler.scheduleRecurringReminder(reminder: reminder, transaction: transaction, locale: 'en', remainingBalance: 200.00);

        expect(notificationId, equals(2043));

        final captured = verify(
          () => mockNotificationService.scheduleNotification(
            id: captureAny(named: 'id'),
            title: captureAny(named: 'title'),
            body: captureAny(named: 'body'),
            scheduledDate: captureAny(named: 'scheduledDate'),
            payload: captureAny(named: 'payload'),
          ),
        ).captured;

        expect(captured[0], equals(2043));
        expect(captured[1], contains('Reminder'));
        expect(captured[2], contains('Test Loan'));
        expect(captured[3], equals(DateTime(2025, 12, 15, 19, 0, 0)));
      });

      test('should throw error when scheduling recurring reminder in the past', () async {
        final reminderDate = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 2
          ..transactionId = 43
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 43
          ..type = TransactionType.loan
          ..name = 'Test Loan'
          ..amount = 20000
          ..currency = Currency.usd
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        expect(() => scheduler.scheduleRecurringReminder(reminder: reminder, transaction: transaction, locale: 'en', remainingBalance: 200.00), throwsA(isA<ArgumentError>()));
      });

      test('should generate unique notification ID for recurring reminder', () async {
        final reminderDate = DateTime(2025, 12, 20);
        final reminder = Reminder()
          ..id = 5
          ..transactionId = 10
          ..type = ReminderType.recurring
          ..intervalDays = 14
          ..nextReminderDate = reminderDate
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 10
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 15000
          ..currency = Currency.eur
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) async => {});

        final notificationId = await scheduler.scheduleRecurringReminder(reminder: reminder, transaction: transaction, locale: 'en', remainingBalance: 150.00);

        expect(notificationId, equals(5010));
      });
    });

    group('cancelReminder', () {
      test('should cancel notification', () async {
        when(() => mockNotificationService.cancelNotification(any())).thenAnswer((_) async => {});

        await scheduler.cancelReminder(123);

        verify(() => mockNotificationService.cancelNotification(123)).called(1);
      });
    });
  });
}
