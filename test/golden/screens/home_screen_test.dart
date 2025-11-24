import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';

class MockDatabaseService implements DatabaseService {
  final bool _isInitialized;

  MockDatabaseService({required bool isInitialized})
      : _isInitialized = isInitialized;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Isar get instance => throw UnimplementedError();

  @override
  Future<bool> close() => throw UnimplementedError();

  @override
  Future<Isar> initialize() => throw UnimplementedError();
}

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
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
            ],
            home: SizedBox(
              width: 400,
              height: 800,
              child: HomeScreen(
                databaseService: MockDatabaseService(isInitialized: true),
              ),
            ),
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
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
            ],
            home: SizedBox(
              width: 400,
              height: 800,
              child: HomeScreen(
                databaseService: MockDatabaseService(isInitialized: false),
              ),
            ),
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
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
            ],
            home: SizedBox(
              width: 400,
              height: 800,
              child: HomeScreen(
                databaseService: MockDatabaseService(isInitialized: true),
              ),
            ),
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
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
            ],
            home: SizedBox(
              width: 400,
              height: 800,
              child: HomeScreen(
                databaseService: MockDatabaseService(isInitialized: false),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
