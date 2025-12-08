import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deptsandloans/core/providers/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    late LocaleProvider provider;

    setUp(() {
      provider = LocaleProvider();
    });

    test('initial locale is null', () {
      expect(provider.locale, isNull);
    });

    test('setLocale updates locale and notifies listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      provider.setLocale(const Locale('pl'));

      expect(provider.locale, const Locale('pl'));
      expect(notified, isTrue);
    });

    test('matchLocale returns Polish when device locale is Polish', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('pl'), supportedLocales);

      expect(result, const Locale('pl'));
    });

    test('matchLocale returns English when device locale is English', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('en'), supportedLocales);

      expect(result, const Locale('en'));
    });

    test('matchLocale defaults to English when device locale is not supported', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('de'), supportedLocales);

      expect(result, const Locale('en'));
    });

    test('matchLocale defaults to English for French device locale', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('fr'), supportedLocales);

      expect(result, const Locale('en'));
    });

    test('matchLocale defaults to English for Spanish device locale', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('es'), supportedLocales);

      expect(result, const Locale('en'));
    });

    test('matchLocale matches only by language code, ignoring country code', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final result = provider.matchLocale(const Locale('pl', 'PL'), supportedLocales);

      expect(result, const Locale('pl'));
    });

    test('detectDeviceLocale uses platform locale', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      final detected = provider.detectDeviceLocale(supportedLocales);

      expect(detected.languageCode, isIn(['en', 'pl']));
    });

    test('initializeLocale sets detected locale', () {
      const supportedLocales = [Locale('en'), Locale('pl')];
      provider.initializeLocale(supportedLocales);

      expect(provider.locale, isNotNull);
      expect(provider.locale!.languageCode, isIn(['en', 'pl']));
    });

    test('initializeLocale notifies listeners', () {
      var notified = false;
      provider.addListener(() => notified = true);

      const supportedLocales = [Locale('en'), Locale('pl')];
      provider.initializeLocale(supportedLocales);

      expect(notified, isTrue);
    });

    test('setLocale can change locale multiple times', () {
      provider.setLocale(const Locale('en'));
      expect(provider.locale, const Locale('en'));

      provider.setLocale(const Locale('pl'));
      expect(provider.locale, const Locale('pl'));

      provider.setLocale(const Locale('en'));
      expect(provider.locale, const Locale('en'));
    });
  });
}
