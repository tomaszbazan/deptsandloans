import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  group('TransactionDetailsScreen', () {
    final mockDatabaseService = MockDatabaseService(isInitialized: true);

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
          home: TransactionDetailsScreen(databaseService: mockDatabaseService, transactionId: '789'),
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
          home: TransactionDetailsScreen(databaseService: mockDatabaseService, transactionId: '789'),
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
          home: TransactionDetailsScreen(databaseService: mockDatabaseService, transactionId: '789'),
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
          home: TransactionDetailsScreen(databaseService: mockDatabaseService, transactionId: '789'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Placeholder for transaction details'), findsOneWidget);
    });

    testWidgets('back navigation works with router', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: createAppRouter(mockDatabaseService),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('View Sample Transaction'));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    });

    testWidgets('edit button navigates to edit screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: createAppRouter(mockDatabaseService),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('View Sample Transaction'));
      await tester.pumpAndSettle();

      expect(find.text('Transaction ID: 123'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
      expect(find.text('Transaction ID: 123'), findsOneWidget);
      expect(find.text('Transaction Form (Edit Mode)'), findsOneWidget);
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
            home: TransactionDetailsScreen(databaseService: mockDatabaseService, transactionId: id),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Transaction ID: $id'), findsOneWidget);

        await tester.pumpWidget(Container());
      }
    });
  });
}
