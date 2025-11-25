import 'package:deptsandloans/domain/models/currency.dart';
import 'package:deptsandloans/domain/models/transaction.dart';
import 'package:deptsandloans/domain/models/transaction_status.dart';
import 'package:deptsandloans/domain/models/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Transaction', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    test('creates transaction with all fields', () {
      final transaction = Transaction(
        id: '123',
        type: TransactionType.debt,
        name: 'John Doe',
        amount: 10050,
        currency: Currency.pln,
        description: 'Test description',
        dueDate: tomorrow,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      expect(transaction.id, '123');
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
      final transaction = Transaction(
        id: '123',
        type: TransactionType.loan,
        name: 'Jane Smith',
        amount: 500,
        currency: Currency.eur,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      expect(transaction.id, '123');
      expect(transaction.name, 'Jane Smith');
      expect(transaction.description, null);
      expect(transaction.dueDate, null);
    });

    test('throws assertion error when name is empty', () {
      expect(
        () => Transaction(
          id: '123',
          type: TransactionType.debt,
          name: '                ',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when name is only whitespace', () {
      expect(
        () => Transaction(
          id: '123',
          type: TransactionType.debt,
          name: '   ',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when amount is not positive', () {
      expect(
        () => Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 0,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: -10,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when description exceeds 200 characters', () {
      expect(
        () => Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          description: 'a' * 201,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('accepts description with exactly 200 characters', () {
      final transaction = Transaction(
        id: '123',
        type: TransactionType.debt,
        name: 'John Doe',
        amount: 1000,
        currency: Currency.pln,
        description: 'a' * 200,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      expect(transaction.description?.length, 200);
    });

    test('serializes to JSON correctly', () {
      final transaction = Transaction(
        id: '123',
        type: TransactionType.debt,
        name: 'John Doe',
        amount: 10050,
        currency: Currency.pln,
        description: 'Test description',
        dueDate: DateTime(2024, 12, 31, 10, 30),
        status: TransactionStatus.active,
        createdAt: DateTime(2024, 1, 1, 12, 0),
        updatedAt: DateTime(2024, 1, 1, 12, 0),
      );

      final json = transaction.toJson();

      expect(json['id'], '123');
      expect(json['type'], 'debt');
      expect(json['name'], 'John Doe');
      expect(json['amount'], 10050);
      expect(json['currency'], 'pln');
      expect(json['description'], 'Test description');
      expect(json['due_date'], '2024-12-31T10:30:00.000');
      expect(json['status'], 'active');
      expect(json['created_at'], '2024-01-01T12:00:00.000');
      expect(json['updated_at'], '2024-01-01T12:00:00.000');
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'id': '123',
        'type': 'loan',
        'name': 'Jane Smith',
        'amount': 25075,
        'currency': 'eur',
        'description': 'Loan for car',
        'due_date': '2024-12-31T10:30:00.000',
        'status': 'completed',
        'created_at': '2024-01-01T12:00:00.000',
        'updated_at': '2024-06-15T14:30:00.000',
      };

      final transaction = Transaction.fromJson(json);

      expect(transaction.id, '123');
      expect(transaction.type, TransactionType.loan);
      expect(transaction.name, 'Jane Smith');
      expect(transaction.amount, 25075);
      expect(transaction.currency, Currency.eur);
      expect(transaction.description, 'Loan for car');
      expect(transaction.dueDate, DateTime(2024, 12, 31, 10, 30));
      expect(transaction.status, TransactionStatus.completed);
      expect(transaction.createdAt, DateTime(2024, 1, 1, 12, 0));
      expect(transaction.updatedAt, DateTime(2024, 6, 15, 14, 30));
    });

    test('deserializes from JSON with null optional fields', () {
      final json = {
        'id': '456',
        'type': 'debt',
        'name': 'Bob',
        'amount': 500,
        'currency': 'usd',
        'status': 'active',
        'created_at': '2024-01-01T12:00:00.000',
        'updated_at': '2024-01-01T12:00:00.000',
      };

      final transaction = Transaction.fromJson(json);

      expect(transaction.description, null);
      expect(transaction.dueDate, null);
    });

    test('copyWith creates new instance with updated fields', () {
      final transaction = Transaction(
        id: '123',
        type: TransactionType.debt,
        name: 'John Doe',
        amount: 1000,
        currency: Currency.pln,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      final updated = transaction.copyWith(
        name: 'Jane Doe',
        amount: 2000,
        status: TransactionStatus.completed,
      );

      expect(updated.id, '123');
      expect(updated.name, 'Jane Doe');
      expect(updated.amount, 2000);
      expect(updated.status, TransactionStatus.completed);
      expect(updated.type, TransactionType.debt);
      expect(updated.currency, Currency.pln);
    });

    test('copyWith without parameters returns identical transaction', () {
      final transaction = Transaction(
        id: '123',
        type: TransactionType.debt,
        name: 'John Doe',
        amount: 1000,
        currency: Currency.pln,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      final copy = transaction.copyWith();

      expect(copy.id, transaction.id);
      expect(copy.name, transaction.name);
      expect(copy.amount, transaction.amount);
      expect(copy.status, transaction.status);
    });

    group('isOverdue', () {
      test('returns false when dueDate is null', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isOverdue, false);
      });

      test('returns false when status is completed', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          dueDate: yesterday,
          status: TransactionStatus.completed,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isOverdue, false);
      });

      test('returns true when dueDate is in the past and status is active', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          dueDate: yesterday,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isOverdue, true);
      });

      test('returns false when dueDate is in the future', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          dueDate: tomorrow,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isOverdue, false);
      });
    });

    group('isActive', () {
      test('returns true when status is active', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isActive, true);
      });

      test('returns false when status is completed', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.completed,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isActive, false);
      });
    });

    group('isCompleted', () {
      test('returns true when status is completed', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.completed,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isCompleted, true);
      });

      test('returns false when status is active', () {
        final transaction = Transaction(
          id: '123',
          type: TransactionType.debt,
          name: 'John Doe',
          amount: 1000,
          currency: Currency.pln,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.isCompleted, false);
      });
    });

    test('supports all transaction types', () {
      final debt = Transaction(
        id: '1',
        type: TransactionType.debt,
        name: 'Test',
        amount: 100,
        currency: Currency.pln,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      final loan = Transaction(
        id: '2',
        type: TransactionType.loan,
        name: 'Test',
        amount: 100,
        currency: Currency.pln,
        status: TransactionStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      expect(debt.type, TransactionType.debt);
      expect(loan.type, TransactionType.loan);
    });

    test('supports all currencies', () {
      final currencies = [
        Currency.pln,
        Currency.eur,
        Currency.usd,
        Currency.gbp,
      ];

      for (final currency in currencies) {
        final transaction = Transaction(
          id: '1',
          type: TransactionType.debt,
          name: 'Test',
          amount: 100,
          currency: currency,
          status: TransactionStatus.active,
          createdAt: now,
          updatedAt: now,
        );

        expect(transaction.currency, currency);
      }
    });
  });
}
