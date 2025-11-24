import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/screens/transaction_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  group('TransactionFormScreen', () {
    testWidgets('displays new transaction mode correctly', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          home: TransactionFormScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('New Transaction'), findsOneWidget);
      expect(find.text('Transaction Form (New)'), findsOneWidget);
      expect(find.text('Edit Transaction'), findsNothing);
      expect(find.byIcon(Icons.note_add), findsOneWidget);
    });

    testWidgets('displays edit transaction mode correctly', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          home: TransactionFormScreen(
            databaseService: mockDatabaseService,
            transactionId: '456',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
      expect(find.text('Transaction Form (Edit Mode)'), findsOneWidget);
      expect(find.text('Transaction ID: 456'), findsOneWidget);
      expect(find.text('New Transaction'), findsNothing);
    });

    testWidgets('displays transaction type when provided', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          home: TransactionFormScreen(
            databaseService: mockDatabaseService,
            transactionType: 'loan',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Type: loan'), findsOneWidget);
    });

    testWidgets('has back button in app bar', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          home: TransactionFormScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('placeholder message is visible', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          home: TransactionFormScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Placeholder for transaction form'), findsOneWidget);
    });

    testWidgets('back navigation works with router', (tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: createAppRouter(mockDatabaseService),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Form (New)'), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    });
  });
}
