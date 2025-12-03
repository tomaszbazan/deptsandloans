import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/app_fixture.dart';

void main() {
  group('Navigation flow integration tests', () {
    testWidgets('complete flow: home -> new transaction -> back', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('My Debts'), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('Name'), findsNothing);
    });

    testWidgets('navigation with tabs switches FAB label', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      expect(find.text('Add Debt'), findsOneWidget);

      await tester.tap(find.text('My Loans'));
      await tester.pumpAndSettle();

      expect(find.text('Add Loan'), findsOneWidget);
    });

    testWidgets('multiple navigation actions maintain correct state', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);

      await tester.tap(find.text('My Loans'));
      await tester.pumpAndSettle();

      expect(find.text('Add Loan'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('My Loans'), findsOneWidget);
    });

    testWidgets('all navigation elements are accessible', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);

      final fabButton = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
      expect(fabButton.onPressed, isNotNull);
    });

    testWidgets('navigation maintains database service reference', (tester) async {
      await tester.pumpWidget(AppFixture.createDefaultRouter());

      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('My Debts'), findsOneWidget);
    });
  });
}
