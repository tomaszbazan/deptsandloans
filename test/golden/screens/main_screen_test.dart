import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_transaction_repository.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  var emptyTransactionRepository = MockTransactionRepository();
  var nonEmptyTransactionRepository = MockTransactionRepository();
  nonEmptyTransactionRepository.create(
    TransactionFixture.createTransaction(
      type: TransactionType.debt,
      name: 'Money owed to John',
      amount: 10000,
      currency: Currency.pln,
      description: 'Description',
      dueDate: DateTime(2025, 01, 01),
    ),
  );
  nonEmptyTransactionRepository.create(
    TransactionFixture.createTransaction(
      type: TransactionType.debt,
      name: 'Money owed to Jane',
      amount: 12345,
      currency: Currency.eur
    ),
  );
  nonEmptyTransactionRepository.create(
    TransactionFixture.createTransaction(
      type: TransactionType.loan,
      name: 'Money lent to John',
      amount: 10000,
      currency: Currency.pln,
      description: 'Description',
      dueDate: DateTime(2025, 01, 01),
    ),
  );
  nonEmptyTransactionRepository.create(
    TransactionFixture.createTransaction(
        type: TransactionType.loan,
        name: 'Money lent to Jane',
        amount: 12345,
        currency: Currency.eur
    ),
  );

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
              child: MainScreen(transactionRepository: emptyTransactionRepository, repaymentRepository: MockRepaymentRepository()),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: emptyTransactionRepository, repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'debts_tab',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: nonEmptyTransactionRepository, repaymentRepository: MockRepaymentRepository()),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: nonEmptyTransactionRepository, repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
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
              child: MainScreen(transactionRepository: emptyTransactionRepository, repaymentRepository: MockRepaymentRepository()),
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
              child: MainScreen(transactionRepository: emptyTransactionRepository, repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'debts_tab_dark',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 800,
              child: MainScreen(transactionRepository: nonEmptyTransactionRepository, repaymentRepository: MockRepaymentRepository()),
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
              child: MainScreen(transactionRepository: nonEmptyTransactionRepository, repaymentRepository: MockRepaymentRepository(), initialIndex: 1),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
