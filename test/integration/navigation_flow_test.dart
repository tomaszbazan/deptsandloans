import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_database_service.dart';

void main() {
  group('Navigation flow integration tests', () {
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockDatabaseService = createMockDatabaseService();
    });

    testWidgets('complete flow: home -> new transaction -> back', (tester) async {
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

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Form (New)'), findsOneWidget);
      expect(find.text('Welcome to Debts and Loans'), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
      expect(find.text('Transaction Form (New)'), findsNothing);
    });

    testWidgets('complete flow: home -> transaction details -> edit -> back -> back', (tester) async {
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

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);

      await tester.tap(find.text('View Sample Transaction'));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));
      expect(find.text('Transaction ID: 123'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
      expect(find.text('Transaction Form (Edit Mode)'), findsOneWidget);
      expect(find.text('Transaction ID: 123'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));
      expect(find.text('Transaction ID: 123'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    });

    testWidgets('navigation with query parameters preserves type', (tester) async {
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

      await tester.tap(find.text('Add New Transaction'));
      await tester.pumpAndSettle();

      expect(find.text('Type: debt'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    });

    testWidgets('multiple navigation actions maintain correct state', (tester) async {
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

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);

      await tester.tap(find.text('View Sample Transaction'));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Transaction Details'), findsAtLeast(1));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    });

    testWidgets('all navigation buttons are accessible', (tester) async {
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

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add New Transaction'), findsOneWidget);
      expect(find.text('View Sample Transaction'), findsOneWidget);

      final fabButton = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
      expect(fabButton.onPressed, isNotNull);
    });

    testWidgets('navigation maintains database service reference', (tester) async {
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

      expect(find.text('Database: Ready'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Database: Ready'), findsOneWidget);
    });
  });
}
