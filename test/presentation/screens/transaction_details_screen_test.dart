import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  group('TransactionDetailsScreen', () {
    late MockTransactionRepository transactionRepository;
    late MockRepaymentRepository repaymentRepository;

    setUp(() {
      transactionRepository = MockTransactionRepository();
      repaymentRepository = MockRepaymentRepository();
    });

    testWidgets('shows loading state while fetching data', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays transaction details correctly', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        description: 'Test description',
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsOneWidget);
      expect(find.text('Test Transaction'), findsOneWidget);
      expect(find.text('Debt'), findsOneWidget);
    });

    testWidgets('has back button in app bar', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('has edit button in app bar', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('shows error state for non-existent transaction', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '999')),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transaction not found'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('has delete button in app bar', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('shows confirmation dialog when delete button is tapped', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        id: 1,
        name: 'Test Transaction',
        type: TransactionType.debt,
        amount: 10000,
        currency: Currency.usd,
        status: TransactionStatus.active,
      );

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete Transaction?'), findsOneWidget);
      expect(find.text('This action cannot be undone. The transaction and all associated repayments will be permanently deleted.'), findsOneWidget);
      expect(find.text('Transaction: Test Transaction'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('closes dialog without deletion when cancel is tapped', (tester) async {
      final transaction = TransactionFixture.createTransaction();

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Transaction?'), findsNothing);

      final retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction, isNotNull);
    });

    testWidgets('deletes transaction and navigates back when confirmed', (tester) async {
      final transaction = TransactionFixture.createTransaction();

      await transactionRepository.create(transaction);

      await tester.pumpWidget(
        AppFixture.createDefaultApp(TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1')),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Transaction deleted successfully'), findsOneWidget);

      final retrievedTransaction = await transactionRepository.getById(transaction.id);
      expect(retrievedTransaction, isNull);
    });
  });
}
