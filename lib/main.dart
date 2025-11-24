import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final databaseService = DatabaseService();
    await databaseService.initialize();

    developer.log('Application starting with database initialized', name: 'main');

    runApp(DeptsAndLoansApp(databaseService: databaseService));
  } catch (e, stackTrace) {
    developer.log('Failed to initialize application', name: 'main', level: 1000, error: e, stackTrace: stackTrace);

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}

class DeptsAndLoansApp extends StatelessWidget {
  final DatabaseService databaseService;

  const DeptsAndLoansApp({required this.databaseService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: createAppRouter(databaseService),
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
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
    );
  }
}
