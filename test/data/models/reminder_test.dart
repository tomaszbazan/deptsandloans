import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reminder', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    test('creates one-time reminder with all fields', () {
      final reminder = Reminder()
        ..transactionId = 1
        ..type = ReminderType.oneTime
        ..intervalDays = null
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      expect(reminder.transactionId, 1);
      expect(reminder.type, ReminderType.oneTime);
      expect(reminder.intervalDays, null);
      expect(reminder.nextReminderDate, tomorrow);
      expect(reminder.createdAt, now);
    });

    test('creates recurring reminder with all fields', () {
      final reminder = Reminder()
        ..transactionId = 1
        ..type = ReminderType.recurring
        ..intervalDays = 7
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      expect(reminder.transactionId, 1);
      expect(reminder.type, ReminderType.recurring);
      expect(reminder.intervalDays, 7);
      expect(reminder.nextReminderDate, tomorrow);
      expect(reminder.createdAt, now);
    });

    test('isOneTime returns true for one-time reminder', () {
      final reminder = Reminder()
        ..transactionId = 1
        ..type = ReminderType.oneTime
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      expect(reminder.isOneTime, true);
      expect(reminder.isRecurring, false);
    });

    test('isRecurring returns true for recurring reminder', () {
      final reminder = Reminder()
        ..transactionId = 1
        ..type = ReminderType.recurring
        ..intervalDays = 7
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      expect(reminder.isRecurring, true);
      expect(reminder.isOneTime, false);
    });

    test('supports various interval days for recurring reminders', () {
      final intervals = [1, 7, 14, 30, 90];

      for (final interval in intervals) {
        final reminder = Reminder()
          ..transactionId = 1
          ..type = ReminderType.recurring
          ..intervalDays = interval
          ..nextReminderDate = tomorrow
          ..createdAt = now;

        expect(reminder.intervalDays, interval);
      }
    });

    test('supports future reminder dates', () {
      final futureDate = now.add(const Duration(days: 30));
      final reminder = Reminder()
        ..transactionId = 1
        ..type = ReminderType.oneTime
        ..nextReminderDate = futureDate
        ..createdAt = now;

      expect(reminder.nextReminderDate, futureDate);
      expect(reminder.nextReminderDate.isAfter(now), true);
    });

    test('multiple reminders can reference same transaction', () {
      final reminder1 = Reminder()
        ..transactionId = 1
        ..type = ReminderType.oneTime
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      final reminder2 = Reminder()
        ..transactionId = 1
        ..type = ReminderType.recurring
        ..intervalDays = 7
        ..nextReminderDate = tomorrow
        ..createdAt = now;

      expect(reminder1.transactionId, reminder2.transactionId);
      expect(reminder1.type, isNot(reminder2.type));
    });

    group('validate', () {
      group('one-time reminder validation', () {
        test('passes validation when intervalDays is null', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.oneTime
            ..intervalDays = null
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), returnsNormally);
        });

        test('throws ArgumentError when intervalDays is set', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.oneTime
            ..intervalDays = 7
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('One-time reminders must have null intervalDays'))));
        });

        test('throws ArgumentError when intervalDays is 0', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.oneTime
            ..intervalDays = 0
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('One-time reminders must have null intervalDays'))));
        });

        test('throws ArgumentError when intervalDays is 1', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.oneTime
            ..intervalDays = 1
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('One-time reminders must have null intervalDays'))));
        });
      });

      group('recurring reminder validation', () {
        test('passes validation when intervalDays is positive', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.recurring
            ..intervalDays = 7
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), returnsNormally);
        });

        test('passes validation when intervalDays is 1', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.recurring
            ..intervalDays = 1
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), returnsNormally);
        });

        test('throws ArgumentError when intervalDays is null', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.recurring
            ..intervalDays = null
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Recurring reminders must have intervalDays > 0'))));
        });

        test('throws ArgumentError when intervalDays is 0', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.recurring
            ..intervalDays = 0
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Recurring reminders must have intervalDays > 0'))));
        });

        test('throws ArgumentError when intervalDays is negative', () {
          final reminder = Reminder()
            ..transactionId = 1
            ..type = ReminderType.recurring
            ..intervalDays = -1
            ..nextReminderDate = tomorrow
            ..createdAt = now;

          expect(() => reminder.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Recurring reminders must have intervalDays > 0'))));
        });
      });
    });
  });
}
