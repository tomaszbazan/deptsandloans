import 'package:deptsandloans/data/models/repayment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repayment', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    test('creates repayment with all fields', () {
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 5000
        ..when = yesterday
        ..createdAt = now;

      expect(repayment.transactionId, 1);
      expect(repayment.amount, 5000);
      expect(repayment.when, yesterday);
      expect(repayment.createdAt, now);
    });

    test('amountInMainUnit converts correctly from smallest unit', () {
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 10050
        ..when = now
        ..createdAt = now;

      expect(repayment.amountInMainUnit, 100.50);
    });

    test('amountInMainUnit handles zero correctly', () {
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 0
        ..when = now
        ..createdAt = now;

      expect(repayment.amountInMainUnit, 0.0);
    });

    test('supports backdated repayments', () {
      final repaymentDate = now.subtract(const Duration(days: 30));
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 1000
        ..when = repaymentDate
        ..createdAt = now;

      expect(repayment.when, repaymentDate);
      expect(repayment.when.isBefore(repayment.createdAt), true);
    });

    test('allows current date for when field', () {
      final currentDate = DateTime.now();
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 1000
        ..when = currentDate;

      expect(repayment.when, currentDate);
    });

    test('allows zero amount repayments', () {
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 0
        ..when = now
        ..createdAt = now;

      expect(repayment.amount, 0);
    });

    test('handles large amounts correctly', () {
      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 999999999
        ..when = now
        ..createdAt = now;

      expect(repayment.amount, 999999999);
      expect(repayment.amountInMainUnit, 9999999.99);
    });

    test('multiple repayments can reference same transaction', () {
      final repayment1 = Repayment()
        ..transactionId = 1
        ..amount = 1000
        ..when = now.subtract(const Duration(days: 2))
        ..createdAt = now.subtract(const Duration(days: 2));

      final repayment2 = Repayment()
        ..transactionId = 1
        ..amount = 2000
        ..when = now.subtract(const Duration(days: 1))
        ..createdAt = now.subtract(const Duration(days: 1));

      expect(repayment1.transactionId, repayment2.transactionId);
      expect(repayment1.amount, isNot(repayment2.amount));
    });

    group('validate', () {
      group('amount validation', () {
        test('throws ArgumentError when amount is negative', () {
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = -100
            ..when = yesterday
            ..createdAt = now;

          expect(
            () => repayment.validate(),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Amount cannot be negative'),
              ),
            ),
          );
        });

        test('throws ArgumentError when amount is -1', () {
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = -1
            ..when = yesterday
            ..createdAt = now;

          expect(() => repayment.validate(), throwsA(isA<ArgumentError>()));
        });

        test('does not throw when amount is zero', () {
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 0
            ..when = yesterday
            ..createdAt = now;

          expect(() => repayment.validate(), returnsNormally);
        });

        test('does not throw when amount is positive', () {
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 100
            ..when = yesterday
            ..createdAt = now;

          expect(() => repayment.validate(), returnsNormally);
        });
      });

      group('when validation', () {
        test('throws ArgumentError when date is in future', () {
          final futureDate = DateTime.now().add(const Duration(days: 1));
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 1000
            ..when = futureDate
            ..createdAt = now;

          expect(
            () => repayment.validate(),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                contains('Repayment date cannot be in the future'),
              ),
            ),
          );
        });

        test('throws ArgumentError when date is 1 second in future', () {
          final futureDate = DateTime.now().add(const Duration(seconds: 1));
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 1000
            ..when = futureDate
            ..createdAt = now;

          expect(() => repayment.validate(), throwsA(isA<ArgumentError>()));
        });

        test('does not throw when date is current', () {
          final currentDate = DateTime.now();
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 1000
            ..when = currentDate
            ..createdAt = now;

          expect(() => repayment.validate(), returnsNormally);
        });

        test('does not throw when date is in past', () {
          final pastDate = DateTime.now().subtract(const Duration(days: 1));
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 1000
            ..when = pastDate
            ..createdAt = now;

          expect(() => repayment.validate(), returnsNormally);
        });

        test('does not throw when date is 1 year ago', () {
          final pastDate = DateTime.now().subtract(const Duration(days: 365));
          final repayment = Repayment()
            ..transactionId = 1
            ..amount = 1000
            ..when = pastDate
            ..createdAt = now;

          expect(() => repayment.validate(), returnsNormally);
        });
      });

      test('collects all validation errors', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final repayment = Repayment()
          ..transactionId = 1
          ..amount = -100
          ..when = futureDate
          ..createdAt = now;

        expect(
          () => repayment.validate(),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('Amount cannot be negative'),
                contains('Repayment date cannot be in the future'),
              ),
            ),
          ),
        );
      });
    });
  });
}
