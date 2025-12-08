import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Multi-Currency Display Tests', () {
    group('English Locale (en)', () {
      const locale = Locale('en');

      testWidgets('displays PLN correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: locale)),
            ),
          ),
        );

        expect(find.text('zł1,234.56'), findsOneWidget);
      });

      testWidgets('displays EUR correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: locale)),
            ),
          ),
        );

        expect(find.text('€1,234.56'), findsOneWidget);
      });

      testWidgets('displays USD correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.usd, locale: locale)),
            ),
          ),
        );

        expect(find.text('\$1,234.56'), findsOneWidget);
      });

      testWidgets('displays GBP correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.gbp, locale: locale)),
            ),
          ),
        );

        expect(find.text('£1,234.56'), findsOneWidget);
      });
    });

    group('Polish Locale (pl)', () {
      const locale = Locale('pl');

      testWidgets('displays PLN correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: locale)),
            ),
          ),
        );

        expect(find.text('1\u00A0234,56\u00A0zł'), findsOneWidget);
      });

      testWidgets('displays EUR correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: locale)),
            ),
          ),
        );

        expect(find.text('1\u00A0234,56\u00A0€'), findsOneWidget);
      });

      testWidgets('displays USD correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.usd, locale: locale)),
            ),
          ),
        );

        expect(find.text('1\u00A0234,56\u00A0\$'), findsOneWidget);
      });

      testWidgets('displays GBP correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            home: Scaffold(
              body: Text(CurrencyFormatter.format(amount: 1234.56, currency: Currency.gbp, locale: locale)),
            ),
          ),
        );

        expect(find.text('1\u00A0234,56\u00A0£'), findsOneWidget);
      });
    });

    group('Locale Comparison', () {
      test('PLN formatting differs between locales', () {
        const amount = 1234.56;
        const currency = Currency.pln;

        final enFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('en'));
        final plFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('pl'));

        expect(enFormat, equals('zł1,234.56'));
        expect(plFormat, equals('1\u00A0234,56\u00A0zł'));
        expect(enFormat, isNot(equals(plFormat)));
      });

      test('EUR formatting differs between locales', () {
        const amount = 1234.56;
        const currency = Currency.eur;

        final enFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('en'));
        final plFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('pl'));

        expect(enFormat, equals('€1,234.56'));
        expect(plFormat, equals('1\u00A0234,56\u00A0€'));
        expect(enFormat, isNot(equals(plFormat)));
      });

      test('USD formatting differs between locales', () {
        const amount = 1234.56;
        const currency = Currency.usd;

        final enFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('en'));
        final plFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('pl'));

        expect(enFormat, equals('\$1,234.56'));
        expect(plFormat, equals('1\u00A0234,56\u00A0\$'));
        expect(enFormat, isNot(equals(plFormat)));
      });

      test('GBP formatting differs between locales', () {
        const amount = 1234.56;
        const currency = Currency.gbp;

        final enFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('en'));
        final plFormat = CurrencyFormatter.format(amount: amount, currency: currency, locale: const Locale('pl'));

        expect(enFormat, equals('£1,234.56'));
        expect(plFormat, equals('1\u00A0234,56\u00A0£'));
        expect(enFormat, isNot(equals(plFormat)));
      });
    });
  });
}
