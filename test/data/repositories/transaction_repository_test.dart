import 'dart:io';

import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/exceptions/repository_exceptions.dart';
import 'package:deptsandloans/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Isar isar;
  late TransactionRepositoryImpl repository;
  final testDbDir = Directory('build/test_db');

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    if (!testDbDir.existsSync()) {
      testDbDir.createSync(recursive: true);
    }
  });

  setUp(() async {
    isar = await Isar.open([TransactionSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');
    repository = TransactionRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('TransactionRepositoryImpl', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    Transaction createValidTransaction({
      int id = Isar.autoIncrement,
      TransactionType type = TransactionType.debt,
      String name = 'John Doe',
      int amount = 10000,
      Currency currency = Currency.pln,
      String? description,
      DateTime? dueDate,
      TransactionStatus status = TransactionStatus.active,
    }) {
      return Transaction()
        ..id = id
        ..type = type
        ..name = name
        ..amount = amount
        ..currency = currency
        ..description = description
        ..dueDate = dueDate
        ..status = status
        ..createdAt = now
        ..updatedAt = now;
    }

    group('create', () {
      test('throws TransactionRepositoryException on validation error', () async {
        final transaction = createValidTransaction(name: '');

        expect(() => repository.create(transaction), throwsA(isA<TransactionRepositoryException>().having((e) => e.message, 'message', 'Failed to create transaction')));
      });

      test('successfully creates a transaction', () async {
        final transaction = createValidTransaction(dueDate: tomorrow);

        await repository.create(transaction);

        final savedTransaction = await isar.transactions.get(transaction.id);
        expect(savedTransaction, isNotNull);
        expect(savedTransaction!.name, equals('John Doe'));
        expect(savedTransaction.amount, equals(10000));
        expect(savedTransaction.type, equals(TransactionType.debt));
      });
    });

    group('getById', () {
      test('returns null when transaction not found', () async {
        final transaction = await repository.getById(999);

        expect(transaction, isNull);
      });

      test('successfully returns transaction when it exists', () async {
        final transaction = createValidTransaction(name: 'Test Transaction');
        await repository.create(transaction);

        final retrieved = await repository.getById(transaction.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(transaction.id));
        expect(retrieved.name, equals('Test Transaction'));
        expect(retrieved.amount, equals(10000));
      });
    });

    group('getByType', () {
      test('returns empty list when no transactions exist', () async {
        final transactions = await repository.getByType(TransactionType.debt);

        expect(transactions, isEmpty);
      });

      test('returns only transactions of specified type', () async {
        final debt1 = createValidTransaction(type: TransactionType.debt, name: 'Debt 1');
        final debt2 = createValidTransaction(type: TransactionType.debt, name: 'Debt 2');
        final loan = createValidTransaction(type: TransactionType.loan, name: 'Loan 1');

        await repository.create(debt1);
        await repository.create(debt2);
        await repository.create(loan);

        final debts = await repository.getByType(TransactionType.debt);
        final loans = await repository.getByType(TransactionType.loan);

        expect(debts, hasLength(2));
        expect(debts.every((t) => t.type == TransactionType.debt), isTrue);
        expect(loans, hasLength(1));
        expect(loans.first.type, equals(TransactionType.loan));
      });
    });

    group('update', () {
      test('throws TransactionNotFoundException when transaction not found', () async {
        final transaction = createValidTransaction(id: 999);

        expect(() => repository.update(transaction), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('throws TransactionRepositoryException on validation error', () async {
        final transaction = createValidTransaction();
        await repository.create(transaction);

        final invalidTransaction = createValidTransaction(id: transaction.id, name: '');

        expect(() => repository.update(invalidTransaction), throwsA(isA<TransactionRepositoryException>().having((e) => e.message, 'message', 'Failed to update transaction')));
      });

      test('successfully updates a transaction', () async {
        final transaction = createValidTransaction(name: 'Original Name');
        await repository.create(transaction);

        final updatedTransaction = createValidTransaction(id: transaction.id, name: 'Updated Name', amount: 20000);

        await repository.update(updatedTransaction);

        final savedTransaction = await isar.transactions.get(transaction.id);
        expect(savedTransaction, isNotNull);
        expect(savedTransaction!.name, equals('Updated Name'));
        expect(savedTransaction.amount, equals(20000));
      });
    });

    group('delete', () {
      test('throws TransactionNotFoundException when transaction not found', () async {
        expect(() => repository.delete(999), throwsA(isA<TransactionNotFoundException>().having((e) => e.id, 'id', 999)));
      });

      test('successfully deletes a transaction', () async {
        final transaction = createValidTransaction();
        await repository.create(transaction);

        await repository.delete(transaction.id);

        final deletedTransaction = await isar.transactions.get(transaction.id);
        expect(deletedTransaction, isNull);
      });
    });
  });
}
