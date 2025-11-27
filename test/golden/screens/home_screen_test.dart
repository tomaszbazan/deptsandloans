import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  goldenTest(
    'HomeScreen displays correctly',
    fileName: 'home_screen',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'database_initialized',
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: HomeScreen(databaseService: createMockDatabaseService())),
          ),
        ),
        GoldenTestScenario(
          name: 'database_not_initialized',
          child: MaterialApp(
            theme: AppTheme.lightTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: HomeScreen(databaseService: _databaseNotInitialized())),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'HomeScreen displays correctly in dark mode',
    fileName: 'home_screen_dark',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'database_initialized_dark',
          child: MaterialApp(
            theme: AppTheme.darkTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: HomeScreen(databaseService: createMockDatabaseService())),
          ),
        ),
        GoldenTestScenario(
          name: 'database_not_initialized_dark',
          child: MaterialApp(
            theme: AppTheme.darkTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pl')],
            home: SizedBox(width: 400, height: 800, child: HomeScreen(databaseService: _databaseNotInitialized())),
          ),
        ),
      ],
    ),
  );
}

MockDatabaseService _databaseNotInitialized() {
  var mockDatabaseService = createMockDatabaseService();
  when(() => mockDatabaseService.isInitialized).thenReturn(false);
  return mockDatabaseService;
}
