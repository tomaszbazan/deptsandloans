import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import '../../mocks/mock_database_service.dart';

void main() {
  group('HomeScreen localization tests', () {
    testWidgets('displays English texts when locale is en',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
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
          home: HomeScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
      expect(find.text('Database: Ready'), findsOneWidget);

      expect(find.text('Długi i Pożyczki'), findsNothing);
      expect(find.text('Witaj w Długach i Pożyczkach'), findsNothing);
      expect(find.text('Baza danych: Gotowa'), findsNothing);
    });

    testWidgets('displays Polish texts when locale is pl',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
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
          home: HomeScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Witaj w Długach i Pożyczkach'), findsOneWidget);
      expect(find.text('Baza danych: Gotowa'), findsOneWidget);

      expect(find.text('Debts and Loans'), findsNothing);
      expect(find.text('Welcome to Debts and Loans'), findsNothing);
      expect(find.text('Database: Ready'), findsNothing);
    });

    testWidgets('displays correct database status for uninitialized database',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService(isInitialized: false);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
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
          home: HomeScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Database: Not initialized'), findsOneWidget);
      expect(find.text('Database: Ready'), findsNothing);

      final textWidget =
          tester.widget<Text>(find.text('Database: Not initialized'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets(
        'displays Polish database status for uninitialized database',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService(isInitialized: false);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
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
          home: HomeScreen(databaseService: mockDatabaseService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Baza danych: Niezainicjalizowana'), findsOneWidget);
      expect(find.text('Baza danych: Gotowa'), findsNothing);

      final textWidget = tester
          .widget<Text>(find.text('Baza danych: Niezainicjalizowana'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('changes language from English to Polish dynamically',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService();
      final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, child) {
            return MaterialApp(
              locale: locale,
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
              home: HomeScreen(databaseService: mockDatabaseService),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
      expect(find.text('Database: Ready'), findsOneWidget);

      localeNotifier.value = const Locale('pl');
      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Witaj w Długach i Pożyczkach'), findsOneWidget);
      expect(find.text('Baza danych: Gotowa'), findsOneWidget);

      expect(find.text('Debts and Loans'), findsNothing);
      expect(find.text('Welcome to Debts and Loans'), findsNothing);
      expect(find.text('Database: Ready'), findsNothing);
    });

    testWidgets('changes language from Polish to English dynamically',
        (WidgetTester tester) async {
      final mockDatabaseService = MockDatabaseService();
      final localeNotifier = ValueNotifier<Locale>(const Locale('pl'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, child) {
            return MaterialApp(
              locale: locale,
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
              home: HomeScreen(databaseService: mockDatabaseService),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Długi i Pożyczki'), findsOneWidget);
      expect(find.text('Witaj w Długach i Pożyczkach'), findsOneWidget);
      expect(find.text('Baza danych: Gotowa'), findsOneWidget);

      localeNotifier.value = const Locale('en');
      await tester.pumpAndSettle();

      expect(find.text('Debts and Loans'), findsOneWidget);
      expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
      expect(find.text('Database: Ready'), findsOneWidget);

      expect(find.text('Długi i Pożyczki'), findsNothing);
      expect(find.text('Witaj w Długach i Pożyczkach'), findsNothing);
      expect(find.text('Baza danych: Gotowa'), findsNothing);
    });
  });
}
