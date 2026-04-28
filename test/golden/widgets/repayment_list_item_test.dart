import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/repayment_list_item.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/repayment_fixture.dart';

void main() {
  goldenTest(
    'RepaymentListItem displays correctly',
    fileName: 'repayment_list_item',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'pln_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 5000, when: DateTime(2024, 11, 15, 14, 30)),
                currency: Currency.pln,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'eur_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 12500, when: DateTime(2024, 10, 20, 9, 15)),
                currency: Currency.eur,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'usd_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 7500, when: DateTime(2024, 9, 5, 16, 45)),
                currency: Currency.usd,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'gbp_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 10000, when: DateTime(2024, 8, 10, 11, 0)),
                currency: Currency.gbp,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'RepaymentListItem displays correctly in dark mode',
    fileName: 'repayment_list_item_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'pln_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 5000, when: DateTime(2024, 11, 15, 14, 30)),
                currency: Currency.pln,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'usd_currency',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 100,
              child: RepaymentListItem(
                repayment: RepaymentFixture.createRepayment(amount: 7500, when: DateTime(2024, 9, 5, 16, 45)),
                currency: Currency.usd,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
