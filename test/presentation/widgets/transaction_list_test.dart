import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  group('TransactionList', () {
    late MockRepaymentRepository mockRepaymentRepository;

    setUp(() {
      mockRepaymentRepository = MockRepaymentRepository();
    });

    testWidgets('displays empty state when no transactions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: Scaffold(
            body: TransactionList(
              transactions: [],
              repaymentRepository: mockRepaymentRepository,
              emptyState: const Center(child: Text('No transactions')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No transactions'), findsOneWidget);
    });

    testWidgets('displays list of transactions', (tester) async {
      final transactions = [
        TransactionFixture.createTransaction(id: 1, name: 'Transaction 1'),
        TransactionFixture.createTransaction(id: 2, name: 'Transaction 2'),
        TransactionFixture.createTransaction(id: 3, name: 'Transaction 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: Scaffold(
            body: TransactionList(
              transactions: transactions,
              repaymentRepository: mockRepaymentRepository,
              emptyState: const Center(child: Text('No transactions')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transaction 1'), findsOneWidget);
      expect(find.text('Transaction 2'), findsOneWidget);
      expect(find.text('Transaction 3'), findsOneWidget);
    });

    testWidgets('calculates balance correctly with no repayments', (tester) async {
      final transaction = TransactionFixture.createTransaction(id: 1, amount: 10000, currency: Currency.pln);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: Scaffold(
            body: TransactionList(
              transactions: [transaction],
              repaymentRepository: mockRepaymentRepository,
              emptyState: const Center(child: Text('No transactions')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsOneWidget);
    });

    testWidgets('calculates balance correctly with repayments', (tester) async {
      final transaction = TransactionFixture.createTransaction(id: 1, amount: 10000, currency: Currency.pln);

      final repayment = Repayment()
        ..transactionId = 1
        ..amount = 3000
        ..when = DateTime.now()
        ..createdAt = DateTime.now();

      await mockRepaymentRepository.addRepayment(repayment);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: Scaffold(
            body: TransactionList(
              transactions: [transaction],
              repaymentRepository: mockRepaymentRepository,
              emptyState: const Center(child: Text('No transactions')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsOneWidget);
    });

    testWidgets('handles transaction tap callback', (tester) async {
      final transaction = TransactionFixture.createTransaction(id: 1);
      Transaction? tappedTransaction;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: Scaffold(
            body: TransactionList(
              transactions: [transaction],
              repaymentRepository: mockRepaymentRepository,
              emptyState: const Center(child: Text('No transactions')),
              onTransactionTap: (t) {
                tappedTransaction = t;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(tappedTransaction, equals(transaction));
    });
  });
}
