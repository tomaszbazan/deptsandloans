import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  group('MainScreen navigation tests', () {
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockDatabaseService = createMockDatabaseService();
    });

    testWidgets('displays tabs and FAB', (tester) async {
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

      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FAB navigates to new transaction screen', (tester) async {
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

      expect(find.text('Add Debt'), findsOneWidget);
    });

    testWidgets('back navigation from transaction form works', (tester) async {
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

      expect(find.text('Add Debt'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('Add Debt'), findsOneWidget);
      expect(find.text('Name'), findsNothing);
    });
  });
}
