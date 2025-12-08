import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Currency Edge Cases', () {
    group('Very Small Amounts', () {
      test('formats 0.01 correctly in English', () {
        final result = CurrencyFormatter.format(amount: 0.01, currency: Currency.pln, locale: const Locale('en'));
        expect(result, equals('zł0.01'));
      });

      test('formats 0.01 correctly in Polish', () {
        final result = CurrencyFormatter.format(amount: 0.01, currency: Currency.pln, locale: const Locale('pl'));
        expect(result, equals('0,01\u00A0zł'));
      });

      test('formats 0.99 correctly in English', () {
        final result = CurrencyFormatter.format(amount: 0.99, currency: Currency.eur, locale: const Locale('en'));
        expect(result, equals('€0.99'));
      });

      test('formats 0.99 correctly in Polish', () {
        final result = CurrencyFormatter.format(amount: 0.99, currency: Currency.eur, locale: const Locale('pl'));
        expect(result, equals('0,99\u00A0€'));
      });
    });

    group('Large Amounts', () {
      test('formats 1,000,000 correctly in English', () {
        final result = CurrencyFormatter.format(amount: 1000000.00, currency: Currency.usd, locale: const Locale('en'));
        expect(result, equals('\$1,000,000.00'));
      });

      test('formats 1,000,000 correctly in Polish', () {
        final result = CurrencyFormatter.format(amount: 1000000.00, currency: Currency.usd, locale: const Locale('pl'));
        expect(result, equals('1\u00A0000\u00A0000,00\u00A0\$'));
      });

      test('formats 999,999,999.99 correctly in English', () {
        final result = CurrencyFormatter.format(amount: 999999999.99, currency: Currency.gbp, locale: const Locale('en'));
        expect(result, equals('£999,999,999.99'));
      });

      test('formats 999,999,999.99 correctly in Polish', () {
        final result = CurrencyFormatter.format(amount: 999999999.99, currency: Currency.gbp, locale: const Locale('pl'));
        expect(result, equals('999\u00A0999\u00A0999,99\u00A0£'));
      });
    });

    group('Zero Amounts', () {
      test('formats 0.00 correctly in English for all currencies', () {
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.pln, locale: const Locale('en')), equals('zł0.00'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.eur, locale: const Locale('en')), equals('€0.00'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.usd, locale: const Locale('en')), equals('\$0.00'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.gbp, locale: const Locale('en')), equals('£0.00'));
      });

      test('formats 0.00 correctly in Polish for all currencies', () {
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.pln, locale: const Locale('pl')), equals('0,00\u00A0zł'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.eur, locale: const Locale('pl')), equals('0,00\u00A0€'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.usd, locale: const Locale('pl')), equals('0,00\u00A0\$'));
        expect(CurrencyFormatter.format(amount: 0.00, currency: Currency.gbp, locale: const Locale('pl')), equals('0,00\u00A0£'));
      });
    });

    group('Negative Amounts', () {
      test('formats negative amounts correctly in English', () {
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.pln, locale: const Locale('en')), equals('-zł1,234.56'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.eur, locale: const Locale('en')), equals('-€1,234.56'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.usd, locale: const Locale('en')), equals('-\$1,234.56'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.gbp, locale: const Locale('en')), equals('-£1,234.56'));
      });

      test('formats negative amounts correctly in Polish', () {
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.pln, locale: const Locale('pl')), equals('-1\u00A0234,56\u00A0zł'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.eur, locale: const Locale('pl')), equals('-1\u00A0234,56\u00A0€'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.usd, locale: const Locale('pl')), equals('-1\u00A0234,56\u00A0\$'));
        expect(CurrencyFormatter.format(amount: -1234.56, currency: Currency.gbp, locale: const Locale('pl')), equals('-1\u00A0234,56\u00A0£'));
      });
    });

    group('Decimal Precision', () {
      test('rounds to 2 decimal places in English', () {
        expect(CurrencyFormatter.format(amount: 1234.56789, currency: Currency.pln, locale: const Locale('en')), equals('zł1,234.57'));
        expect(CurrencyFormatter.format(amount: 1234.564, currency: Currency.eur, locale: const Locale('en')), equals('€1,234.56'));
        expect(CurrencyFormatter.format(amount: 1234.565, currency: Currency.usd, locale: const Locale('en')), equals('\$1,234.57'));
      });

      test('rounds to 2 decimal places in Polish', () {
        expect(CurrencyFormatter.format(amount: 1234.56789, currency: Currency.pln, locale: const Locale('pl')), equals('1\u00A0234,57\u00A0zł'));
        expect(CurrencyFormatter.format(amount: 1234.564, currency: Currency.eur, locale: const Locale('pl')), equals('1\u00A0234,56\u00A0€'));
        expect(CurrencyFormatter.format(amount: 1234.565, currency: Currency.usd, locale: const Locale('pl')), equals('1\u00A0234,57\u00A0\$'));
      });
    });

    group('Mixed Currencies', () {
      test('handles multiple currencies in same locale correctly', () {
        const locale = Locale('en');

        final pln = CurrencyFormatter.format(amount: 100.00, currency: Currency.pln, locale: locale);
        final eur = CurrencyFormatter.format(amount: 200.00, currency: Currency.eur, locale: locale);
        final usd = CurrencyFormatter.format(amount: 300.00, currency: Currency.usd, locale: locale);
        final gbp = CurrencyFormatter.format(amount: 400.00, currency: Currency.gbp, locale: locale);

        expect(pln, equals('zł100.00'));
        expect(eur, equals('€200.00'));
        expect(usd, equals('\$300.00'));
        expect(gbp, equals('£400.00'));

        expect(pln, isNot(equals(eur)));
        expect(eur, isNot(equals(usd)));
        expect(usd, isNot(equals(gbp)));
      });

      test('handles multiple currencies in Polish locale correctly', () {
        const locale = Locale('pl');

        final pln = CurrencyFormatter.format(amount: 100.00, currency: Currency.pln, locale: locale);
        final eur = CurrencyFormatter.format(amount: 200.00, currency: Currency.eur, locale: locale);
        final usd = CurrencyFormatter.format(amount: 300.00, currency: Currency.usd, locale: locale);
        final gbp = CurrencyFormatter.format(amount: 400.00, currency: Currency.gbp, locale: locale);

        expect(pln, equals('100,00\u00A0zł'));
        expect(eur, equals('200,00\u00A0€'));
        expect(usd, equals('300,00\u00A0\$'));
        expect(gbp, equals('400,00\u00A0£'));

        expect(pln, isNot(equals(eur)));
        expect(eur, isNot(equals(usd)));
        expect(usd, isNot(equals(gbp)));
      });
    });

    group('Thousands Separators', () {
      test('applies correct thousands separators in English', () {
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: const Locale('en')), contains(','));
        expect(CurrencyFormatter.format(amount: 12345.67, currency: Currency.eur, locale: const Locale('en')), contains(','));
        expect(CurrencyFormatter.format(amount: 123456.78, currency: Currency.usd, locale: const Locale('en')), contains(','));
      });

      test('applies correct thousands separators in Polish', () {
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: const Locale('pl')), contains('\u00A0'));
        expect(CurrencyFormatter.format(amount: 12345.67, currency: Currency.eur, locale: const Locale('pl')), contains('\u00A0'));
        expect(CurrencyFormatter.format(amount: 123456.78, currency: Currency.usd, locale: const Locale('pl')), contains('\u00A0'));
      });
    });

    group('Decimal Separators', () {
      test('uses dot as decimal separator in English', () {
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: const Locale('en')), contains('.56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: const Locale('en')), contains('.56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.usd, locale: const Locale('en')), contains('.56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.gbp, locale: const Locale('en')), contains('.56'));
      });

      test('uses comma as decimal separator in Polish', () {
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.pln, locale: const Locale('pl')), contains(',56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.eur, locale: const Locale('pl')), contains(',56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.usd, locale: const Locale('pl')), contains(',56'));
        expect(CurrencyFormatter.format(amount: 1234.56, currency: Currency.gbp, locale: const Locale('pl')), contains(',56'));
      });
    });
  });
}
