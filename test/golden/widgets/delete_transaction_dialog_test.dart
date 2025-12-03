import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';

void main() {
  goldenTest(
    'Delete transaction dialog displays correctly',
    fileName: 'delete_transaction_dialog',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [GoldenTestScenario(name: 'light', child: _buildScenario(AppTheme.lightTheme()))],
    ),
  );

  goldenTest(
    'Delete transaction dialog displays correctly in dark mode',
    fileName: 'delete_transaction_dialog_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [GoldenTestScenario(name: 'dark', child: _buildScenario(AppTheme.darkTheme()))],
    ),
  );
}

Widget _buildScenario(ThemeData theme) {
  final transaction = Transaction()
    ..id = 1
    ..type = TransactionType.debt
    ..name = 'Loan from John'
    ..amount = 100000
    ..currency = Currency.pln
    ..description = 'Borrowed for renovation'
    ..dueDate = DateTime(2025, 12, 31)
    ..status = TransactionStatus.active
    ..createdAt = DateTime(2025, 1, 1)
    ..updatedAt = DateTime(2025, 1, 1);

  return AppFixture.createDefaultApp(
    AlertDialog(
      title: const Text('Delete Transaction?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This action cannot be undone. The transaction and all associated repayments will be permanently deleted.'),
          const SizedBox(height: 16),
          Text('Transaction: ${transaction.name}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Cancel')),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          child: const Text('Delete'),
        ),
      ],
    ),
    theme: theme,
  );
}
