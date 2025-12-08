import 'dart:ui';

import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter', () {
    group('format', () {
      test('formats USD in en_US locale correctly', () {
        final result = CurrencyFormatter.format(amount: 1234.56, currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(result, '\$1,234.56');
      });

      test('formats EUR in en_US locale correctly', () {
        final result = CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: const Locale('en', 'US'));

        expect(result, '€1,234.56');
      });

      test('formats PLN in pl_PL locale correctly', () {
        final result = CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: const Locale('pl', 'PL'));

        expect(result, '1\u00A0234,56\u00A0zł');
      });

      test('formats EUR in pl_PL locale correctly', () {
        final result = CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: const Locale('pl', 'PL'));

        expect(result, '1\u00A0234,56\u00A0€');
      });

      test('formats GBP in en_GB locale correctly', () {
        final result = CurrencyFormatter.format(amount: 1234.56, currency: Currency.gbp, locale: const Locale('en', 'GB'));

        expect(result, '£1,234.56');
      });

      test('formats zero amount correctly', () {
        final result = CurrencyFormatter.format(amount: 0.0, currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(result, '\$0.00');
      });

      test('formats negative amount correctly', () {
        final result = CurrencyFormatter.format(amount: -1234.56, currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(result, '-\$1,234.56');
      });

      test('formats small decimal correctly', () {
        final result = CurrencyFormatter.format(amount: 0.99, currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(result, '\$0.99');
      });

      test('formats large amount correctly', () {
        final result = CurrencyFormatter.format(amount: 1234567.89, currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(result, '\$1,234,567.89');
      });
    });

    group('getFormatter', () {
      test('returns NumberFormat with correct locale and symbol', () {
        final formatter = CurrencyFormatter.getFormatter(currency: Currency.usd, locale: const Locale('en', 'US'));

        expect(formatter.format(1234.56), '\$1,234.56');
      });

      test('can be reused for multiple amounts', () {
        final formatter = CurrencyFormatter.getFormatter(currency: Currency.eur, locale: const Locale('pl', 'PL'));

        expect(formatter.format(100.0), '100,00\u00A0€');
        expect(formatter.format(200.0), '200,00\u00A0€');
        expect(formatter.format(300.0), '300,00\u00A0€');
      });
    });
  });
}
