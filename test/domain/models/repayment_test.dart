import 'package:deptsandloans/domain/models/repayment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repayment', () {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    test('creates repayment with all fields', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 10050,
        when: yesterday,
        createdAt: now,
      );

      expect(repayment.id, 'rep123');
      expect(repayment.transactionId, 'txn123');
      expect(repayment.amount, 10050);
      expect(repayment.when, yesterday);
      expect(repayment.createdAt, now);
    });

    test('throws assertion error when amount is not positive', () {
      expect(
        () => Repayment(
          id: 'rep123',
          transactionId: 'txn123',
          amount: 0,
          when: yesterday,
          createdAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Repayment(
          id: 'rep123',
          transactionId: 'txn123',
          amount: -100,
          when: yesterday,
          createdAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when repayment date is in the future', () {
      expect(
        () => Repayment(
          id: 'rep123',
          transactionId: 'txn123',
          amount: 10050,
          when: tomorrow,
          createdAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('accepts repayment date of today', () {
      final today = DateTime(now.year, now.month, now.day);
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 5000,
        when: today,
        createdAt: now,
      );

      expect(repayment.when, today);
    });

    test('serializes to JSON correctly', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn456',
        amount: 15075,
        when: DateTime(2024, 6, 15, 14, 30),
        createdAt: DateTime(2024, 6, 15, 14, 35),
      );

      final json = repayment.toJson();

      expect(json['id'], 'rep123');
      expect(json['transaction_id'], 'txn456');
      expect(json['amount'], 15075);
      expect(json['when'], '2024-06-15T14:30:00.000');
      expect(json['created_at'], '2024-06-15T14:35:00.000');
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'id': 'rep789',
        'transaction_id': 'txn999',
        'amount': 25000,
        'when': '2024-05-20T10:00:00.000',
        'created_at': '2024-05-20T10:05:00.000',
      };

      final repayment = Repayment.fromJson(json);

      expect(repayment.id, 'rep789');
      expect(repayment.transactionId, 'txn999');
      expect(repayment.amount, 25000);
      expect(repayment.when, DateTime(2024, 5, 20, 10, 0));
      expect(repayment.createdAt, DateTime(2024, 5, 20, 10, 5));
    });

    test('copyWith creates new instance with updated fields', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 10000,
        when: yesterday,
        createdAt: now,
      );

      final updated = repayment.copyWith(
        amount: 15000,
        when: DateTime(2024, 1, 1),
      );

      expect(updated.id, 'rep123');
      expect(updated.transactionId, 'txn123');
      expect(updated.amount, 15000);
      expect(updated.when, DateTime(2024, 1, 1));
      expect(updated.createdAt, now);
    });

    test('copyWith without parameters returns identical repayment', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 10000,
        when: yesterday,
        createdAt: now,
      );

      final copy = repayment.copyWith();

      expect(copy.id, repayment.id);
      expect(copy.transactionId, repayment.transactionId);
      expect(copy.amount, repayment.amount);
      expect(copy.when, repayment.when);
      expect(copy.createdAt, repayment.createdAt);
    });

    test('handles large amounts correctly', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 999999999,
        when: yesterday,
        createdAt: now,
      );

      expect(repayment.amount, 999999999);
    });

    test('handles small amounts correctly', () {
      final repayment = Repayment(
        id: 'rep123',
        transactionId: 'txn123',
        amount: 1,
        when: yesterday,
        createdAt: now,
      );

      expect(repayment.amount, 1);
    });

    test('roundtrip JSON serialization preserves data', () {
      final original = Repayment(
        id: 'rep123',
        transactionId: 'txn456',
        amount: 12345,
        when: DateTime(2024, 3, 15, 9, 30),
        createdAt: DateTime(2024, 3, 15, 9, 35),
      );

      final json = original.toJson();
      final deserialized = Repayment.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.transactionId, original.transactionId);
      expect(deserialized.amount, original.amount);
      expect(deserialized.when, original.when);
      expect(deserialized.createdAt, original.createdAt);
    });

    test('can reference different transactions', () {
      final repayment1 = Repayment(
        id: 'rep1',
        transactionId: 'txn1',
        amount: 5000,
        when: yesterday,
        createdAt: now,
      );

      final repayment2 = Repayment(
        id: 'rep2',
        transactionId: 'txn2',
        amount: 3000,
        when: yesterday,
        createdAt: now,
      );

      expect(repayment1.transactionId, 'txn1');
      expect(repayment2.transactionId, 'txn2');
      expect(repayment1.transactionId, isNot(equals(repayment2.transactionId)));
    });
  });
}
