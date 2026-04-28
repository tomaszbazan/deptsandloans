import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/presentation/providers/repayment_provider.dart';
import 'package:deptsandloans/presentation/widgets/repayment_form.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  goldenTest(
    'RepaymentForm displays correctly',
    fileName: 'repayment_form',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'initial_state',
          child: _buildScenario(remainingBalance: 500.0, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'with_high_balance',
          child: _buildScenario(remainingBalance: 99999.99, theme: AppTheme.lightTheme()),
        ),
      ],
    ),
  );

  goldenTest(
    'RepaymentForm displays correctly in dark mode',
    fileName: 'repayment_form_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'initial_state_dark',
          child: _buildScenario(remainingBalance: 500.0, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'with_high_balance_dark',
          child: _buildScenario(remainingBalance: 99999.99, theme: AppTheme.darkTheme()),
        ),
      ],
    ),
  );
}

Widget _buildScenario({required double remainingBalance, required ThemeData theme}) {
  final repository = MockRepaymentRepository();
  final provider = RepaymentProvider(repository);

  return AppFixture.createDefaultApp(
    Material(
      child: SizedBox(
        width: 400,
        height: 600,
        child: RepaymentForm(
          provider: provider,
          transactionId: 1,
          transactionName: 'Test Transaction',
          remainingBalance: remainingBalance,
          currency: Currency.pln,
          onSuccess: () {},
        ),
      ),
    ),
    theme: theme,
  );
}
