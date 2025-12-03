import 'dart:io';

import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/repositories/isar_repayment_repository.dart';
import 'package:deptsandloans/data/repositories/isar_transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../fixtures/transaction_fixture.dart';

void main() {
  late Isar isar;
  late IsarTransactionRepository transactionRepository;
  late IsarRepaymentRepository repaymentRepository;
  final testDbDir = Directory('build/test_db');

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    if (!testDbDir.existsSync()) {
      testDbDir.createSync(recursive: true);
    }
  });

  setUp(() async {
    isar = await Isar.open([TransactionSchema, RepaymentSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');
    transactionRepository = IsarTransactionRepository(isar);
    repaymentRepository = IsarRepaymentRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('Repayment flow integration tests', () {
    test('complete flow: create transaction, add repayments until auto-completion', () async {
      final transaction = TransactionFixture.createTransaction(amount: 10000);
      await transactionRepository.create(transaction);

      var retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction, isNotNull);
      expect(retrievedTransaction!.isActive, isTrue);

      final repayment1 = Repayment()
        ..transactionId = transaction.id
        ..amount = 3000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment1);

      retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction!.isActive, isTrue);

      final totalRepaid1 = await repaymentRepository.totalRepaid(transaction.id);
      expect(totalRepaid1, equals(30.0));

      final repayment2 = Repayment()
        ..transactionId = transaction.id
        ..amount = 5000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment2);

      retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction!.isActive, isTrue);

      final totalRepaid2 = await repaymentRepository.totalRepaid(transaction.id);
      expect(totalRepaid2, equals(80.0));

      final repayment3 = Repayment()
        ..transactionId = transaction.id
        ..amount = 2000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment3);

      retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction!.isCompleted, isTrue);

      final totalRepaid3 = await repaymentRepository.totalRepaid(transaction.id);
      expect(totalRepaid3, equals(100.0));

      final allRepayments = await repaymentRepository.getRepaymentsByTransactionId(transaction.id);
      expect(allRepayments, hasLength(3));
    });

    test('single repayment completes transaction', () async {
      final transaction = TransactionFixture.createTransaction(amount: 5000);
      await transactionRepository.create(transaction);

      final repayment = Repayment()
        ..transactionId = transaction.id
        ..amount = 5000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment);

      final retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction, isNotNull);
      expect(retrievedTransaction!.isCompleted, isTrue);

      final totalRepaid = await repaymentRepository.totalRepaid(transaction.id);
      expect(totalRepaid, equals(50.0));
    });

    test('multiple transactions are tracked independently', () async {
      final transaction1 = TransactionFixture.createTransaction(id: 100, amount: 10000);
      final transaction2 = TransactionFixture.createTransaction(id: 200, amount: 8000);
      await transactionRepository.create(transaction1);
      await transactionRepository.create(transaction2);

      final repayment1 = Repayment()
        ..transactionId = transaction1.id
        ..amount = 10000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment1);

      var retrievedTransaction1 = await transactionRepository.getById(transaction1.id);
      var retrievedTransaction2 = await transactionRepository.getById(transaction2.id);

      expect(retrievedTransaction1!.isCompleted, isTrue);
      expect(retrievedTransaction2!.isActive, isTrue);

      final repayment2 = Repayment()
        ..transactionId = transaction2.id
        ..amount = 4000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment2);

      retrievedTransaction2 = await transactionRepository.getById(transaction2.id);
      expect(retrievedTransaction2!.isActive, isTrue);

      final repayment3 = Repayment()
        ..transactionId = transaction2.id
        ..amount = 4000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();
      await repaymentRepository.addRepayment(repayment3);

      retrievedTransaction2 = await transactionRepository.getById(transaction2.id);
      expect(retrievedTransaction2!.isCompleted, isTrue);
    });
  });
}
