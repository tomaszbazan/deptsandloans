import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_screen.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_reminder_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  goldenTest(
    'TransactionFormScreen displays correctly',
    fileName: 'transaction_form_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'add_debt', child: _buildScenario(TransactionType.debt, null, AppTheme.lightTheme())),
        GoldenTestScenario(name: 'add_loan', child: _buildScenario(TransactionType.loan, null, AppTheme.lightTheme())),
        GoldenTestScenario(name: 'edit_transaction', child: _buildEditScenario(AppTheme.lightTheme())),
      ],
    ),
  );

  goldenTest(
    'TransactionFormScreen displays correctly in dark mode',
    fileName: 'transaction_form_screen_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'add_debt_dark', child: _buildScenario(TransactionType.debt, null, AppTheme.darkTheme())),
        GoldenTestScenario(name: 'add_loan_dark', child: _buildScenario(TransactionType.loan, null, AppTheme.darkTheme())),
        GoldenTestScenario(name: 'edit_transaction_dark', child: _buildEditScenario(AppTheme.darkTheme())),
      ],
    ),
  );
}

Widget _buildScenario(TransactionType type, int? transactionId, ThemeData theme) {
  return AppFixture.createDefaultApp(
    SizedBox(
      width: 400,
      height: 800,
      child: TransactionFormScreen(transactionRepository: MockTransactionRepository(), reminderRepository: MockReminderRepository(), type: type, transactionId: transactionId),
    ),
    theme: theme,
  );
}

Widget _buildEditScenario(ThemeData theme) {
  final repository = MockTransactionRepository();
  repository.create(
    Transaction()
      ..id = 123
      ..type = TransactionType.debt
      ..name = 'Test Debt'
      ..amount = 50000
      ..currency = Currency.eur
      ..description = 'This is a test description'
      ..dueDate = DateTime(2025, 12, 31)
      ..status = TransactionStatus.active
      ..createdAt = DateTime(2025, 1, 1)
      ..updatedAt = DateTime(2025, 1, 1),
  );

  return AppFixture.createDefaultApp(
    SizedBox(
      width: 400,
      height: 800,
      child: TransactionFormScreen(transactionRepository: repository, reminderRepository: MockReminderRepository(), type: TransactionType.debt, transactionId: 123),
    ),
    theme: theme,
  );
}
