import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository_impl.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  group('TransactionFormScreen', () {
    late MockDatabaseService mockDatabaseService;

    setUpAll(() async {
      await initializeTestIsar();
    });

    setUp(() {
      mockDatabaseService = createMockDatabaseService();
    });

    testWidgets('displays new debt transaction mode correctly', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Debt'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays edit transaction mode correctly', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.debt,
            transactionId: 456,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
    });

    testWidgets('displays loan type correctly', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.loan,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Loan'), findsOneWidget);
    });

    testWidgets('has all form fields', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
      expect(find.text('Description (optional)'), findsOneWidget);
      expect(find.text('Due Date (optional)'), findsOneWidget);
    });

    testWidgets('currency dropdown shows all currencies', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('PLN'), findsOneWidget);
    });

    testWidgets('date picker opens when tapping due date field', (tester) async {
      final repository = TransactionRepositoryImpl(mockDatabaseService.instance);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(
            repository: repository,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Not set'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
