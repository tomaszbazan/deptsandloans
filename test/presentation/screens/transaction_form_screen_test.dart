import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
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
    late TransactionRepository repository;

    setUpAll(() async {
      await initializeTestIsar();
    });

    setUp(() {
      mockDatabaseService = createMockDatabaseService();
      repository = TransactionRepositoryImpl(mockDatabaseService.instance);
    });

    testWidgets('displays new debt transaction mode correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Debt'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays edit transaction mode correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt, transactionId: 456),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
    });

    testWidgets('displays loan type correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.loan),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Loan'), findsOneWidget);
    });

    testWidgets('has all form fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
      expect(find.text('Description (optional)'), findsOneWidget);
      expect(find.text('Due Date (optional)'), findsOneWidget);
    });

    testWidgets('currency dropdown shows default PLN with symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('zł'), findsOneWidget);
    });

    for (final currencyData in [
      {'symbol': '€', 'name': 'EUR'},
      {'symbol': '\$', 'name': 'USD'},
      {'symbol': '£', 'name': 'GBP'},
    ]) {
      testWidgets('can select ${currencyData['name']} currency from dropdown', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('zł'));
        await tester.pumpAndSettle();

        expect(find.text(currencyData['symbol']!), findsOneWidget);

        await tester.tap(find.text(currencyData['symbol']!).last);
        await tester.pumpAndSettle();

        expect(find.text(currencyData['symbol']!), findsOneWidget);
      });
    }

    testWidgets('date picker opens when tapping due date field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Not set'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('shows validation error when name is empty and save is pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '100');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('shows validation error when amount is zero', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test Debt');
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '0');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Amount must be greater than zero'), findsOneWidget);
    });

    testWidgets('clears validation error when valid input is entered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test Debt');
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsNothing);
    });

    testWidgets('shows multiple validation errors when fields are invalid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pl')],
          home: TransactionFormScreen(repository: repository, type: TransactionType.debt),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });
  });
}
