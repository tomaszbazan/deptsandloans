import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/core/router/app_router.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/repositories/isar_reminder_repository.dart';
import 'package:deptsandloans/data/repositories/isar_transaction_repository.dart';
import 'package:deptsandloans/data/repositories/isar_repayment_repository.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/core/notifications/local_notifications_service.dart';
import 'package:deptsandloans/core/notifications/notification_service.dart';
import 'package:deptsandloans/core/notifications/notification_scheduler.dart';
import 'package:deptsandloans/core/notifications/recurring_reminder_processor.dart';
import 'package:deptsandloans/services/background_reminder_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

    final databaseService = DatabaseService();
    await databaseService.initialize();

    final notificationService = LocalNotificationsService();
    await notificationService.initialize();

    final notificationScheduler = NotificationScheduler(notificationService);
    final transactionRepository = IsarTransactionRepository(databaseService.instance, notificationScheduler);
    final repaymentRepository = IsarRepaymentRepository(databaseService.instance, notificationScheduler);
    final reminderRepository = IsarReminderRepository(databaseService.instance);

    final backgroundReminderService = BackgroundReminderService(
      processor: RecurringReminderProcessor(
        reminderRepository: reminderRepository,
        repaymentRepository: repaymentRepository,
        transactionRepository: transactionRepository,
        notificationScheduler: notificationScheduler,
      ),
    );

    await backgroundReminderService.initialize();

    developer.log('Application starting with database and notifications initialized', name: 'main');

    runApp(DeptsAndLoansApp(databaseService: databaseService, notificationService: notificationService));
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
  final NotificationService notificationService;

  const DeptsAndLoansApp({required this.databaseService, required this.notificationService, super.key});

  @override
  Widget build(BuildContext context) {
    final notificationScheduler = NotificationScheduler(notificationService);
    final transactionRepository = IsarTransactionRepository(databaseService.instance, notificationScheduler);
    final repaymentRepository = IsarRepaymentRepository(databaseService.instance, notificationScheduler);
    final reminderRepository = IsarReminderRepository(databaseService.instance);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: createAppRouter(
        transactionRepository: transactionRepository,
        repaymentRepository: repaymentRepository,
        reminderRepository: reminderRepository,
        notificationScheduler: notificationScheduler,
      ),
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [Locale('en'), Locale('pl')],
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
