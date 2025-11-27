import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository_impl.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_screen.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  setUpAll(() async {
    await initializeTestIsar();
  });

  goldenTest(
    'TransactionFormScreen displays correctly',
    fileName: 'transaction_form_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'add_debt', child: _buildScenario(TransactionType.debt, null, AppTheme.lightTheme())),
        GoldenTestScenario(name: 'add_loan', child: _buildScenario(TransactionType.loan, null, AppTheme.lightTheme())),
        GoldenTestScenario(name: 'edit_transaction', child: _buildScenario(TransactionType.debt, 123, AppTheme.lightTheme())),
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
        GoldenTestScenario(name: 'edit_transaction_dark', child: _buildScenario(TransactionType.debt, 123, AppTheme.darkTheme())),
      ],
    ),
  );
}

Widget _buildScenario(TransactionType type, int? transactionId, ThemeData theme) {
  final mockDatabaseService = createMockDatabaseService();
  final repository = TransactionRepositoryImpl(mockDatabaseService.instance);

  return MaterialApp(
    theme: theme,
    localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    supportedLocales: const [Locale('en'), Locale('pl')],
    home: SizedBox(
      width: 400,
      height: 800,
      child: TransactionFormScreen(repository: repository, type: type, transactionId: transactionId),
    ),
  );
}
