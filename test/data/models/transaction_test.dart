import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Transaction', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    test('creates transaction with all fields', () {
      final transaction = Transaction()
        ..type = TransactionType.debt
        ..name = 'John Doe'
        ..amount = 10050
        ..currency = Currency.pln
        ..description = 'Test description'
        ..dueDate = tomorrow
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      expect(transaction.type, TransactionType.debt);
      expect(transaction.name, 'John Doe');
      expect(transaction.amount, 10050);
      expect(transaction.currency, Currency.pln);
      expect(transaction.description, 'Test description');
      expect(transaction.dueDate, tomorrow);
      expect(transaction.status, TransactionStatus.active);
      expect(transaction.createdAt, now);
      expect(transaction.updatedAt, now);
    });

    test('creates transaction with minimal fields', () {
      final transaction = Transaction()
        ..type = TransactionType.loan
        ..name = 'Jane Smith'
        ..amount = 500
        ..currency = Currency.eur
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      expect(transaction.name, 'Jane Smith');
      expect(transaction.description, null);
      expect(transaction.dueDate, null);
    });

    test('amountInMainUnit converts correctly from smallest unit', () {
      final transaction = Transaction()
        ..amount = 10050
        ..type = TransactionType.debt
        ..name = 'Test'
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      expect(transaction.amountInMainUnit, 100.50);
    });

    test('amountInMainUnit handles zero correctly', () {
      final transaction = Transaction()
        ..amount = 0
        ..type = TransactionType.debt
        ..name = 'Test'
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      expect(transaction.amountInMainUnit, 0.0);
    });

    group('isOverdue', () {
      test('returns false when dueDate is null', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isOverdue, false);
      });

      test('returns false when status is completed', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..dueDate = yesterday
          ..status = TransactionStatus.completed
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isOverdue, false);
      });

      test('returns true when dueDate is in the past and status is active', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..dueDate = yesterday
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isOverdue, true);
      });

      test('returns false when dueDate is in the future', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..dueDate = tomorrow
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isOverdue, false);
      });
    });

    group('isActive', () {
      test('returns true when status is active', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isActive, true);
      });

      test('returns false when status is completed', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.completed
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isActive, false);
      });
    });

    group('isCompleted', () {
      test('returns true when status is completed', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.completed
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isCompleted, true);
      });

      test('returns false when status is active', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.isCompleted, false);
      });
    });

    test('supports all transaction types', () {
      final debt = Transaction()
        ..type = TransactionType.debt
        ..name = 'Test'
        ..amount = 100
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      final loan = Transaction()
        ..type = TransactionType.loan
        ..name = 'Test'
        ..amount = 100
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = now
        ..updatedAt = now;

      expect(debt.type, TransactionType.debt);
      expect(loan.type, TransactionType.loan);
    });

    test('supports all currencies', () {
      final currencies = [Currency.pln, Currency.eur, Currency.usd, Currency.gbp];

      for (final currency in currencies) {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'Test'
          ..amount = 100
          ..currency = currency
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(transaction.currency, currency);
      }
    });

    group('validate', () {
      test('passes validation for valid transaction', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..description = 'Valid description'
          ..dueDate = tomorrow
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), returnsNormally);
      });

      test('passes validation with minimal fields', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), returnsNormally);
      });

      test('throws when name is empty', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = ''
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Name must not be empty'))));
      });

      test('throws when name contains only whitespace', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = '   '
          ..amount = 1000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Name must not be empty'))));
      });

      test('throws when amount is zero', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 0
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Amount must be positive'))));
      });

      test('throws when amount is negative', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = -100
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Amount must be positive'))));
      });

      test('throws when description exceeds 200 characters', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..description = 'a' * 201
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Description must not exceed 200 characters'))));
      });

      test('passes when description is exactly 200 characters', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..description = 'a' * 200
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), returnsNormally);
      });

      test('throws when dueDate is in the past', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = 'John Doe'
          ..amount = 1000
          ..currency = Currency.pln
          ..dueDate = yesterday
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(() => transaction.validate(), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('Due date must be in the future'))));
      });

      test('throws with multiple errors combined', () {
        final transaction = Transaction()
          ..type = TransactionType.debt
          ..name = ''
          ..amount = -100
          ..currency = Currency.pln
          ..description = 'a' * 201
          ..dueDate = yesterday
          ..status = TransactionStatus.active
          ..createdAt = now
          ..updatedAt = now;

        expect(
          () => transaction.validate(),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('Name must not be empty'),
                contains('Amount must be positive'),
                contains('Description must not exceed 200 characters'),
                contains('Due date must be in the future'),
              ),
            ),
          ),
        );
      });
    });
  });
}
