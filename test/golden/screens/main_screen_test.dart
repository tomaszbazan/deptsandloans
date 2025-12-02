import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/presentation/screens/main_screen.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  goldenTest(
    'MainScreen displays correctly',
    fileName: 'main_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debts_tab',
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: MainScreen(databaseService: createMockDatabaseService())),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab',
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: MainScreen(databaseService: createMockDatabaseService(), initialIndex: 1)),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'MainScreen displays correctly in dark mode',
    fileName: 'main_screen_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'debts_tab_dark',
          child: MaterialApp(
            theme: AppTheme.darkTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: MainScreen(databaseService: createMockDatabaseService())),
          ),
        ),
        GoldenTestScenario(
          name: 'loans_tab_dark',
          child: MaterialApp(
            theme: AppTheme.darkTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: MainScreen(databaseService: createMockDatabaseService(), initialIndex: 1)),
          ),
        ),
      ],
    ),
  );
}
