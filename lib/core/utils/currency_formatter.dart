import 'dart:ui';

import 'package:deptsandloans/data/models/currency.dart';
import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static String format({required double amount, required Currency currency, required Locale locale}) {
    return NumberFormat.currency(locale: locale.toString(), symbol: currency.symbol, decimalDigits: 2).format(amount);
  }

  static NumberFormat getFormatter({required Currency currency, required Locale locale}) {
    return NumberFormat.currency(locale: locale.toString(), symbol: currency.symbol, decimalDigits: 2);
  }
}
