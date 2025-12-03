import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/providers/repayment_provider.dart';
import 'package:deptsandloans/presentation/widgets/repayment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  group('RepaymentForm', () {
    late MockRepaymentRepository mockRepository;
    late RepaymentProvider provider;

    setUp(() {
      mockRepository = MockRepaymentRepository();
      provider = RepaymentProvider(mockRepository);
    });

    testWidgets('displays all form fields', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 500.0, currency: Currency.pln, onSuccess: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Repayment'), findsOneWidget);
      expect(find.text('Test Transaction'), findsOneWidget);
      expect(find.text('Balance: zł500.00'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('amount field accepts valid decimal input', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 500.0, currency: Currency.pln, onSuccess: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '100.50');
      await tester.pump();

      expect(find.text('100.50'), findsOneWidget);
    });

    testWidgets('shows validation error when amount is empty', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 500.0, currency: Currency.pln, onSuccess: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final saveButton = find.text('Save');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('shows validation error when amount exceeds balance', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 100.0, currency: Currency.pln, onSuccess: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final amountField = find.byType(TextFormField);
      await tester.enterText(amountField, '150.00');
      await tester.pump();

      final saveButton = find.text('Save');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Repayment amount cannot exceed remaining balance'), findsOneWidget);
    });

    testWidgets('cancel button closes the form', (tester) async {
      bool formClosed = false;

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: Navigator(
              onDidRemovePage: (page) {
                formClosed = true;
              },
              pages: [
                MaterialPage<void>(
                  child: Builder(
                    builder: (context) =>
                        RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 500.0, currency: Currency.pln, onSuccess: () {}),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(formClosed, isTrue);
    });

    testWidgets('displays currency symbol in amount field', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Material(
            child: RepaymentForm(provider: provider, transactionId: 1, transactionName: 'Test Transaction', remainingBalance: 500.0, currency: Currency.eur, onSuccess: () {}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('€'), findsOneWidget);
    });
  });
}
