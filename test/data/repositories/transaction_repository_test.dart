import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/exceptions/repository_exceptions.dart';
import 'package:deptsandloans/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

class MockIsar extends Mock implements Isar {}

class MockIsarCollection extends Mock implements IsarCollection<Transaction> {}

typedef WriteTxnCallback = Future<void> Function();

void main() {
  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late TransactionRepositoryImpl repository;

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();
    repository = TransactionRepositoryImpl(mockIsar);

    when(() => mockIsar.transactions).thenReturn(mockCollection);
  });

  group('TransactionRepositoryImpl', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    Transaction createValidTransaction({
      int id = 1,
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
      test('throws TransactionRepositoryException on validation error',
          () async {
        final transaction = createValidTransaction(name: '');

        expect(
          () => repository.create(transaction),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              'Failed to create transaction',
            ),
          ),
        );
      });

      test('throws TransactionRepositoryException on database error', () async {
        final transaction = createValidTransaction(dueDate: tomorrow);

        when(() => mockIsar.writeTxn(any())).thenThrow(Exception('DB error'));

        expect(
          () => repository.create(transaction),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              'Failed to create transaction',
            ),
          ),
        );
      });
    });

    group('getByType', () {
      test('throws TransactionRepositoryException on database error', () async {
        when(() => mockCollection.filter()).thenThrow(Exception('DB error'));

        expect(
          () => repository.getByType(TransactionType.debt),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              contains('Failed to get transactions by type'),
            ),
          ),
        );
      });
    });

    group('update', () {
      test('throws TransactionNotFoundException when transaction not found',
          () async {
        final transaction = createValidTransaction(id: 999);

        when(() => mockCollection.get(999)).thenAnswer((_) async => null);

        expect(
          () => repository.update(transaction),
          throwsA(
            isA<TransactionNotFoundException>().having(
              (e) => e.id,
              'id',
              999,
            ),
          ),
        );

        verify(() => mockCollection.get(999)).called(1);
      });

      test('throws TransactionRepositoryException on validation error',
          () async {
        final existingTransaction = createValidTransaction(id: 1);
        final invalidTransaction = createValidTransaction(id: 1, name: '');

        when(() => mockCollection.get(1))
            .thenAnswer((_) async => existingTransaction);

        expect(
          () => repository.update(invalidTransaction),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              'Failed to update transaction',
            ),
          ),
        );

        verify(() => mockCollection.get(1)).called(1);
      });

      test('throws TransactionRepositoryException on database error', () async {
        final transaction = createValidTransaction(id: 1, dueDate: tomorrow);

        when(() => mockCollection.get(1)).thenAnswer((_) async => transaction);
        when(() => mockIsar.writeTxn(any())).thenThrow(Exception('DB error'));

        expect(
          () => repository.update(transaction),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              'Failed to update transaction',
            ),
          ),
        );
      });
    });

    group('delete', () {
      test('throws TransactionRepositoryException on database error', () async {
        when(() => mockIsar.writeTxn(any())).thenThrow(Exception('DB error'));

        expect(
          () => repository.delete(1),
          throwsA(
            isA<TransactionRepositoryException>().having(
              (e) => e.message,
              'message',
              'Failed to delete transaction',
            ),
          ),
        );
      });
    });
  });
}
