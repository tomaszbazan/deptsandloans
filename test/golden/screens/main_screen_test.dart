import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_transaction_repository.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  goldenTest(
    'MainScreen displays correctly',
    fileName: 'main_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debts_tab',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'MainScreen displays correctly in dark mode',
    fileName: 'main_screen_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debts_tab_dark',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab_dark',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
