import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';

void main() {
  group('TransactionListItem', () {
    testWidgets('displays transaction name', (tester) async {
      final transaction = TransactionFixture.createTransaction(name: 'Test Transaction', amount: 10000, currency: Currency.pln);

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 100.0))));

      await tester.pumpAndSettle();

      expect(find.text('Test Transaction'), findsOneWidget);
    });

    testWidgets('displays amount and balance', (tester) async {
      final transaction = TransactionFixture.createTransaction(amount: 10000, currency: Currency.pln);

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 50.0))));

      await tester.pumpAndSettle();

      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
    });

    testWidgets('displays due date when set', (tester) async {
      final dueDate = DateTime(2025, 12, 31);
      final transaction = TransactionFixture.createTransaction(amount: 10000, currency: Currency.pln, dueDate: dueDate);

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 100.0))));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows overdue badge when transaction is overdue', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        amount: 10000,
        currency: Currency.pln,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.active,
      );

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 50.0))));

      await tester.pumpAndSettle();

      expect(find.text('Overdue'), findsOneWidget);
    });

    testWidgets('does not show overdue badge when completed', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        amount: 10000,
        currency: Currency.pln,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.completed,
      );

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 0.0))));

      await tester.pumpAndSettle();

      expect(find.text('Overdue'), findsNothing);
    });

    testWidgets('does not show overdue badge when balance is zero', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        amount: 10000,
        currency: Currency.pln,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.active,
      );

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 0.0))));

      await tester.pumpAndSettle();

      expect(find.text('Overdue'), findsNothing);
    });

    testWidgets('does not show overdue badge when due date is in future', (tester) async {
      final transaction = TransactionFixture.createTransaction(
        amount: 10000,
        currency: Currency.pln,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        status: TransactionStatus.active,
      );

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 50.0))));

      await tester.pumpAndSettle();

      expect(find.text('Overdue'), findsNothing);
    });

    testWidgets('handles tap callback', (tester) async {
      final transaction = TransactionFixture.createTransaction();
      var tapped = false;

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: TransactionListItem(
              transaction: transaction,
              balance: 100.0,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays different currencies correctly', (tester) async {
      final currencies = [(Currency.pln, 'zł'), (Currency.eur, '€'), (Currency.usd, '\$'), (Currency.gbp, '£')];

      for (final (currency, symbol) in currencies) {
        final transaction = TransactionFixture.createTransaction(amount: 10000, currency: currency);

        await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 100.0))));

        await tester.pumpAndSettle();

        expect(find.textContaining(symbol), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('displays debt type transaction', (tester) async {
      final transaction = TransactionFixture.createTransaction(type: TransactionType.debt, name: 'Money owed to John');

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 100.0))));

      await tester.pumpAndSettle();

      expect(find.text('Money owed to John'), findsOneWidget);
    });

    testWidgets('displays loan type transaction', (tester) async {
      final transaction = TransactionFixture.createTransaction(type: TransactionType.loan, name: 'Money lent to Jane');

      await tester.pumpWidget(AppFixture.createDefaultApp(Scaffold(body: TransactionListItem(transaction: transaction, balance: 100.0))));

      await tester.pumpAndSettle();

      expect(find.text('Money lent to Jane'), findsOneWidget);
    });
  });
}
