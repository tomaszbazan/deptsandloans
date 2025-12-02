import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../mocks/mock_repayment_repository.dart';
import '../mocks/mock_transaction_repository.dart';

class AppFixture {
  static Widget createDefaultApp(Widget child, {String locale = 'en', ThemeData? theme}) {
    return MaterialApp(
      locale: Locale(locale),
      theme: theme ?? AppTheme.lightTheme(),
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('pl')],
      home: child,
    );
  }

  static Widget createDefaultRouter({String locale = 'en'}) {
    return MaterialApp.router(
      locale: Locale(locale),
      routerConfig: createAppRouter(transactionRepository: MockTransactionRepository(), repaymentRepository: MockRepaymentRepository()),
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('pl')],
    );
  }
}
