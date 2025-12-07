import 'package:intl/intl.dart';

class NotificationContentFormatter {
  static String formatTitle(String locale, String transactionType) {
    if (locale.startsWith('pl')) {
      return 'Przypomnienie o Płatności';
    }
    return 'Payment Reminder';
  }

  static String formatBody(String locale, String transactionName, double remainingAmount, String currencySymbol, String transactionType) {
    final formattedAmount = NumberFormat.currency(locale: locale, symbol: currencySymbol, decimalDigits: 2).format(remainingAmount);

    if (locale.startsWith('pl')) {
      if (transactionType == 'debt') {
        return 'Przypomnienie: Zwróć $transactionName - pozostało $formattedAmount';
      } else {
        return 'Przypomnienie: Odbierz od $transactionName - pozostało $formattedAmount';
      }
    }

    if (transactionType == 'debt') {
      return 'Reminder: Pay back $transactionName - $formattedAmount remaining';
    } else {
      return 'Reminder: Collect from $transactionName - $formattedAmount remaining';
    }
  }
}
