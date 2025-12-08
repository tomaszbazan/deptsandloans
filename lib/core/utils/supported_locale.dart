import 'dart:ui';

abstract class SupportedLocale {
  static String defaultLocale = 'en';

  static List<Locale> supportedLocales = [Locale('en'), Locale('pl')];
}