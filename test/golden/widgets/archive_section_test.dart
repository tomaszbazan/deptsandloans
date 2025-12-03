import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/presentation/widgets/archive_section.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  goldenTest(
    'ArchiveSection displays correctly',
    fileName: 'archive_section',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'collapsed_single_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'collapsed_multiple_transactions',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt 1', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 2, name: 'Completed Debt 2', amount: 20000, currency: Currency.eur, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 3, name: 'Completed Debt 3', amount: 30000, currency: Currency.usd, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'expanded_single_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
                initiallyExpanded: true,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'expanded_multiple_transactions',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 600,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt 1', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 2, name: 'Completed Debt 2', amount: 20000, currency: Currency.eur, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 3, name: 'Completed Debt 3', amount: 30000, currency: Currency.usd, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
                initiallyExpanded: true,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'empty_archive',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(completedTransactions: [], repaymentRepository: MockRepaymentRepository()),
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'ArchiveSection displays correctly in dark mode',
    fileName: 'archive_section_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'collapsed_single_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'collapsed_multiple_transactions',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt 1', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 2, name: 'Completed Debt 2', amount: 20000, currency: Currency.eur, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 3, name: 'Completed Debt 3', amount: 30000, currency: Currency.usd, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'expanded_single_transaction',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
                initiallyExpanded: true,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'expanded_multiple_transactions',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 600,
              child: ArchiveSection(
                completedTransactions: [
                  TransactionFixture.createTransaction(id: 1, name: 'Completed Debt 1', amount: 10000, currency: Currency.pln, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 2, name: 'Completed Debt 2', amount: 20000, currency: Currency.eur, status: TransactionStatus.completed),
                  TransactionFixture.createTransaction(id: 3, name: 'Completed Debt 3', amount: 30000, currency: Currency.usd, status: TransactionStatus.completed),
                ],
                repaymentRepository: MockRepaymentRepository(),
                initiallyExpanded: true,
              ),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
        GoldenTestScenario(
          name: 'empty_archive',
          child: AppFixture.createDefaultApp(
            SizedBox(
              width: 400,
              height: 300,
              child: ArchiveSection(completedTransactions: [], repaymentRepository: MockRepaymentRepository()),
            ),
            theme: AppTheme.darkTheme(),
          ),
        ),
      ],
    ),
  );
}
