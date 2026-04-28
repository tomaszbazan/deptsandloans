import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/progress_section.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';

void main() {
  goldenTest(
    'ProgressSection displays correctly',
    fileName: 'progress_section',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'no_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 0.0, remainingAmount: 100.0, currency: Currency.pln, isOverdue: false)),
          ),
        ),
        GoldenTestScenario(
          name: 'partial_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 50.0, remainingAmount: 50.0, currency: Currency.eur, isOverdue: false)),
          ),
        ),
        GoldenTestScenario(
          name: 'almost_complete',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 85.0, remainingAmount: 15.0, currency: Currency.usd, isOverdue: false)),
          ),
        ),
        GoldenTestScenario(
          name: 'complete',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 100.0, remainingAmount: 0.0, currency: Currency.gbp, isOverdue: false)),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue_no_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 0.0, remainingAmount: 100.0, currency: Currency.pln, isOverdue: true)),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue_partial_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 30.0, remainingAmount: 70.0, currency: Currency.usd, isOverdue: true)),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'ProgressSection displays correctly in dark mode',
    fileName: 'progress_section_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'partial_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 50.0, remainingAmount: 50.0, currency: Currency.eur, isOverdue: false)),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue_partial_progress',
          child: AppFixture.createDefaultApp(
            SizedBox(width: 400, child: ProgressSection(originalAmount: 100.0, paidAmount: 30.0, remainingAmount: 70.0, currency: Currency.usd, isOverdue: true)),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
