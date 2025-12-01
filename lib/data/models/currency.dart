enum Currency { pln, eur, usd, gbp }

extension CurrencyExtension on Currency {
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
