import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  goldenTest(
    'TransactionDetailsScreen displays correctly with manual completion button',
    fileName: 'transaction_details_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'active_transaction', child: _buildActiveScenario(AppTheme.lightTheme())),
        GoldenTestScenario(name: 'completed_transaction', child: _buildCompletedScenario(AppTheme.lightTheme())),
      ],
    ),
  );

  goldenTest(
    'TransactionDetailsScreen displays correctly in dark mode',
    fileName: 'transaction_details_screen_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'active_transaction_dark', child: _buildActiveScenario(AppTheme.darkTheme())),
        GoldenTestScenario(name: 'completed_transaction_dark', child: _buildCompletedScenario(AppTheme.darkTheme())),
      ],
    ),
  );
}

Widget _buildActiveScenario(ThemeData theme) {
  final transactionRepository = MockTransactionRepository();
  final repaymentRepository = MockRepaymentRepository();

  transactionRepository.create(
    Transaction()
      ..id = 1
      ..type = TransactionType.debt
      ..name = 'Test Active Debt'
      ..amount = 100000
      ..currency = Currency.usd
      ..description = 'This is an active transaction'
      ..dueDate = DateTime(2025, 12, 31)
      ..status = TransactionStatus.active
      ..createdAt = DateTime(2025, 1, 1)
      ..updatedAt = DateTime(2025, 1, 1),
  );

  return AppFixture.createDefaultApp(
    SizedBox(
      width: 400,
      height: 800,
      child: TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '1'),
    ),
    theme: theme,
  );
}

Widget _buildCompletedScenario(ThemeData theme) {
  final transactionRepository = MockTransactionRepository();
  final repaymentRepository = MockRepaymentRepository();

  transactionRepository.create(
    Transaction()
      ..id = 2
      ..type = TransactionType.loan
      ..name = 'Test Completed Loan'
      ..amount = 50000
      ..currency = Currency.eur
      ..description = 'This is a completed transaction'
      ..dueDate = DateTime(2025, 6, 30)
      ..status = TransactionStatus.completed
      ..createdAt = DateTime(2025, 1, 1)
      ..updatedAt = DateTime(2025, 6, 15),
  );

  return AppFixture.createDefaultApp(
    SizedBox(
      width: 400,
      height: 800,
      child: TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: '2'),
    ),
    theme: theme,
  );
}
