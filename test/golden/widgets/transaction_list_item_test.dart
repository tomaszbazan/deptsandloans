import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';

void main() {
  goldenTest(
    'TransactionListItem displays correctly',
    fileName: 'transaction_list_item',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'basic_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'John Doe', amount: 10000, currency: Currency.pln),
                balance: 100.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'transaction_with_due_date',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'Jane Smith', amount: 50000, currency: Currency.eur, dueDate: DateTime(2025, 12, 31)),
                balance: 500.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(
                  name: 'Bob Johnson',
                  amount: 20000,
                  currency: Currency.usd,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                balance: 150.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'transaction_with_partial_payment',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'Alice Williams', amount: 30000, currency: Currency.gbp),
                balance: 150.0,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'past_due_with_zero_balance',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(
                  name: 'Charlie Brown',
                  amount: 25000,
                  currency: Currency.pln,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                balance: 0.0,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'TransactionListItem displays correctly in dark mode',
    fileName: 'transaction_list_item_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'basic_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'John Doe', amount: 10000, currency: Currency.pln),
                balance: 100.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'transaction_with_due_date',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'Jane Smith', amount: 50000, currency: Currency.eur, dueDate: DateTime(2025, 12, 31)),
                balance: 500.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'overdue_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(
                  name: 'Bob Johnson',
                  amount: 20000,
                  currency: Currency.usd,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                balance: 150.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'transaction_with_partial_payment',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(name: 'Alice Williams', amount: 30000, currency: Currency.gbp),
                balance: 150.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'past_due_with_zero_balance',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 200,
              child: TransactionListItem(
                transaction: TransactionFixture.createTransaction(
                  name: 'Charlie Brown',
                  amount: 25000,
                  currency: Currency.pln,
                  dueDate: DateTime(2024, 1, 1),
                  status: TransactionStatus.active,
                ),
                balance: 0.0,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
