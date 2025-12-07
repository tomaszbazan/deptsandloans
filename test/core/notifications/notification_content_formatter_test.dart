import 'package:deptsandloans/core/notifications/notification_content_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationContentFormatter', () {
    group('formatTitle', () {
      test('returns Polish title for Polish locale', () {
        final result = NotificationContentFormatter.formatTitle('pl_PL', 'debt');
        expect(result, 'Przypomnienie o Płatności');
      });

      test('returns Polish title for pl locale', () {
        final result = NotificationContentFormatter.formatTitle('pl', 'debt');
        expect(result, 'Przypomnienie o Płatności');
      });

      test('returns English title for English locale', () {
        final result = NotificationContentFormatter.formatTitle('en_US', 'debt');
        expect(result, 'Payment Reminder');
      });

      test('returns English title for unknown locale', () {
        final result = NotificationContentFormatter.formatTitle('fr_FR', 'debt');
        expect(result, 'Payment Reminder');
      });
    });

    group('formatBody', () {
      group('Polish locale', () {
        test('formats debt reminder correctly with PLN', () {
          final result = NotificationContentFormatter.formatBody('pl_PL', 'Jan Kowalski', 250.50, 'zł', 'debt');
          expect(result, contains('Przypomnienie: Zwróć Jan Kowalski'));
          expect(result, contains('250,50'));
          expect(result, contains('zł'));
        });

        test('formats loan reminder correctly with EUR', () {
          final result = NotificationContentFormatter.formatBody('pl_PL', 'Anna Nowak', 150.75, '€', 'loan');
          expect(result, contains('Przypomnienie: Odbierz od Anna Nowak'));
          expect(result, contains('150,75'));
          expect(result, contains('€'));
        });

        test('formats with USD symbol', () {
          final result = NotificationContentFormatter.formatBody('pl_PL', 'John Doe', 1000.00, '\$', 'debt');
          expect(result, contains('1'));
          expect(result, contains('000,00'));
          expect(result, contains('\$'));
        });

        test('formats with GBP symbol', () {
          final result = NotificationContentFormatter.formatBody('pl_PL', 'Jane Smith', 500.25, '£', 'loan');
          expect(result, contains('500,25'));
          expect(result, contains('£'));
        });
      });

      group('English locale', () {
        test('formats debt reminder correctly with USD', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'John Doe', 250.50, '\$', 'debt');
          expect(result, contains('Reminder: Pay back John Doe'));
          expect(result, contains('250.50'));
          expect(result, contains('\$'));
        });

        test('formats loan reminder correctly with EUR', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Jane Smith', 150.75, '€', 'loan');
          expect(result, contains('Reminder: Collect from Jane Smith'));
          expect(result, contains('150.75'));
          expect(result, contains('€'));
        });

        test('formats with PLN symbol', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Jan Kowalski', 1000.00, 'zł', 'debt');
          expect(result, contains('1'));
          expect(result, contains('000.00'));
          expect(result, contains('zł'));
        });

        test('formats with GBP symbol', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Anna Nowak', 500.25, '£', 'loan');
          expect(result, contains('500.25'));
          expect(result, contains('£'));
        });
      });

      group('Edge cases', () {
        test('formats very small amounts correctly', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Test User', 0.01, '\$', 'debt');
          expect(result, contains('0.01'));
        });

        test('formats large amounts correctly', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Test User', 999999.99, '\$', 'debt');
          expect(result, contains('999'));
          expect(result, contains('999.99'));
        });

        test('formats zero amount correctly', () {
          final result = NotificationContentFormatter.formatBody('en_US', 'Test User', 0.00, '\$', 'debt');
          expect(result, contains('0.00'));
        });
      });
    });
  });
}
