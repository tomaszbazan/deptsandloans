import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';

void main() {
  group('MainScreen navigation tests', () {
    testWidgets('displays tabs and FAB', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('FAB navigates to new transaction screen', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Debt'), findsOneWidget);
    });

    testWidgets('back navigation from transaction form works', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

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
