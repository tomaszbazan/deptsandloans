import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_transaction_repository.dart';

void main() {
  group('TransactionDetailsScreen', () {
    testWidgets('displays transaction details correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionDetailsScreen(transactionRepository: MockTransactionRepository(), transactionId: '789'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));
      expect(find.text('Transaction ID: 789'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('has back button in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionDetailsScreen(transactionRepository: MockTransactionRepository(), transactionId: '789'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('has edit button in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionDetailsScreen(transactionRepository: MockTransactionRepository(), transactionId: '789'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('placeholder message is visible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionDetailsScreen(transactionRepository: MockTransactionRepository(), transactionId: '789'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Placeholder for transaction details'), findsOneWidget);
    });

    testWidgets('displays different transaction IDs correctly', (tester) async {
      for (final id in ['1', '42', '999', 'abc-123']) {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: TransactionDetailsScreen(transactionRepository: MockTransactionRepository(), transactionId: id),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Transaction ID: $id'), findsOneWidget);

        await tester.pumpWidget(Container());
      }
    });
  });
}
