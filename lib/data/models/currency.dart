enum Currency { pln, eur, usd, gbp }

extension CurrencyExtension on Currency {
  String get code {
    switch (this) {
      case Currency.pln:
        return 'PLN';
      case Currency.eur:
        return 'EUR';
      case Currency.usd:
        return 'USD';
      case Currency.gbp:
        return 'GBP';
    }
  }

  String get symbol {
    switch (this) {
      case Currency.pln:
        return 'zł';
      case Currency.eur:
        return '€';
      case Currency.usd:
        return '\$';
      case Currency.gbp:
        return '£';
    }
  }
}
