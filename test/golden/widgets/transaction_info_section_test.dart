import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/transaction_info_section.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';

void main() {
  goldenTest(
    'TransactionInfoSection displays correctly',
    fileName: 'transaction_info_section',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debt_basic',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'John Doe',
                  amount: 10000,
                  currency: Currency.pln,
                  description: 'Borrowed money for home renovation',
                  status: TransactionStatus.active,
                ),
                remainingBalance: 100.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'loan_basic',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.loan,
                  name: 'Jane Smith',
                  amount: 50000,
                  currency: Currency.eur,
                  description: 'Lent money for business startup',
                  status: TransactionStatus.active,
                ),
                remainingBalance: 500.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'with_due_date',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'Bob Johnson',
                  amount: 20000,
                  currency: Currency.usd,
                  dueDate: DateTime(2025, 12, 31),
                  status: TransactionStatus.active,
                ),
                remainingBalance: 200.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'Alice Williams',
                  amount: 30000,
                  currency: Currency.gbp,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                remainingBalance: 150.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'completed',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.loan,
                  name: 'Charlie Brown',
                  amount: 25000,
                  currency: Currency.pln,
                  status: TransactionStatus.completed,
                ),
                remainingBalance: 0.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'without_description',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'David Martinez',
                  amount: 15000,
                  currency: Currency.usd,
                  description: null,
                  status: TransactionStatus.active,
                ),
                remainingBalance: 150.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'TransactionInfoSection displays correctly in dark mode',
    fileName: 'transaction_info_section_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debt_basic',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'John Doe',
                  amount: 10000,
                  currency: Currency.pln,
                  description: 'Borrowed money for home renovation',
                  status: TransactionStatus.active,
                ),
                remainingBalance: 100.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              child: TransactionInfoSection(
                transaction: TransactionFixture.createTransaction(
                  type: TransactionType.debt,
                  name: 'Alice Williams',
                  amount: 30000,
                  currency: Currency.gbp,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                remainingBalance: 150.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
