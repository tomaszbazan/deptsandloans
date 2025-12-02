import 'package:deptsandloans/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_transaction_repository.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  group('MainScreen localization tests', () {
    testWidgets('displays English texts when locale is en', (WidgetTester tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository())),
      );

      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);

      expect(find.text('Długi i Pożyczki'), findsNothing);
      expect(find.text('Moje Długi'), findsNothing);
      expect(find.text('Moje Pożyczki'), findsNothing);
    });

    testWidgets('displays Polish texts when locale is pl', (WidgetTester tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
          locale: 'pl',
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Moje Długi'), findsOneWidget);
      expect(find.text('Moje Pożyczki'), findsOneWidget);

      expect(find.text('Debts and Loans'), findsNothing);
      expect(find.text('My Debts'), findsNothing);
      expect(find.text('My Loans'), findsNothing);
    });

    testWidgets('changes language from English to Polish dynamically', (WidgetTester tester) async {
      final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, child) {
            return AppFixture.createDefaultApp(
              MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
              locale: locale.languageCode,
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);

      localeNotifier.value = const Locale('pl');
      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Moje Długi'), findsOneWidget);
      expect(find.text('Moje Pożyczki'), findsOneWidget);

      expect(find.text('Debts and Loans'), findsNothing);
      expect(find.text('My Debts'), findsNothing);
      expect(find.text('My Loans'), findsNothing);
    });

    testWidgets('changes language from Polish to English dynamically', (WidgetTester tester) async {
      final localeNotifier = ValueNotifier<Locale>(const Locale('pl'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, child) {
            return AppFixture.createDefaultApp(
              MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
              locale: locale.languageCode,
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Moje Długi'), findsOneWidget);
      expect(find.text('Moje Pożyczki'), findsOneWidget);

      localeNotifier.value = const Locale('en');
      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('My Debts'), findsOneWidget);
      expect(find.text('My Loans'), findsOneWidget);

      expect(find.text('Długi i Pożyczki'), findsNothing);
      expect(find.text('Moje Długi'), findsNothing);
      expect(find.text('Moje Pożyczki'), findsNothing);
    });
  });
}
