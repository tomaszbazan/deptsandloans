import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/repayment_history_section.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/repayment_fixture.dart';

void main() {
  goldenTest(
    'RepaymentHistorySection displays correctly',
    fileName: 'repayment_history_section',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'empty_state',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: RepaymentHistorySection(repayments: [], currency: Currency.pln),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'single_repayment',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: RepaymentHistorySection(
                repayments: [RepaymentFixture.createRepayment(amount: 5000, when: DateTime(2024, 11, 15, 14, 30))],
                currency: Currency.pln,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'multiple_repayments',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: RepaymentHistorySection(
                repayments: [
                  RepaymentFixture.createRepayment(id: 1, amount: 5000, when: DateTime(2024, 11, 15, 14, 30)),
                  RepaymentFixture.createRepayment(id: 2, amount: 3000, when: DateTime(2024, 10, 10, 10, 0)),
                  RepaymentFixture.createRepayment(id: 3, amount: 2000, when: DateTime(2024, 9, 5, 16, 45)),
                ],
                currency: Currency.eur,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'many_repayments',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 600,
              child: RepaymentHistorySection(
                repayments: [
                  RepaymentFixture.createRepayment(id: 1, amount: 5000, when: DateTime(2024, 11, 15, 14, 30)),
                  RepaymentFixture.createRepayment(id: 2, amount: 3000, when: DateTime(2024, 10, 10, 10, 0)),
                  RepaymentFixture.createRepayment(id: 3, amount: 2000, when: DateTime(2024, 9, 5, 16, 45)),
                  RepaymentFixture.createRepayment(id: 4, amount: 1500, when: DateTime(2024, 8, 20, 8, 15)),
                  RepaymentFixture.createRepayment(id: 5, amount: 1000, when: DateTime(2024, 7, 10, 12, 0)),
                ],
                currency: Currency.usd,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'RepaymentHistorySection displays correctly in dark mode',
    fileName: 'repayment_history_section_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'empty_state',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: RepaymentHistorySection(repayments: [], currency: Currency.pln),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'multiple_repayments',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: RepaymentHistorySection(
                repayments: [
                  RepaymentFixture.createRepayment(id: 1, amount: 5000, when: DateTime(2024, 11, 15, 14, 30)),
                  RepaymentFixture.createRepayment(id: 2, amount: 3000, when: DateTime(2024, 10, 10, 10, 0)),
                  RepaymentFixture.createRepayment(id: 3, amount: 2000, when: DateTime(2024, 9, 5, 16, 45)),
                ],
                currency: Currency.eur,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
