import 'dart:ui';

import 'package:flutter/scheduler.dart';

abstract class SupportedLocale {
  static String defaultLocale = 'en';

  static List<Locale> supportedLocales = [Locale('en'), Locale('pl')];

  static String resolveDeviceLocale() {
    final deviceLocale = SchedulerBinding.instance.platformDispatcher.locale;
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale.languageCode;
      }
    }
    return defaultLocale;
  }
}
