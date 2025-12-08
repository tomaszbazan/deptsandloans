import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  Locale matchLocale(Locale deviceLocale, List<Locale> supportedLocales) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }

    return const Locale('en');
  }

  Locale detectDeviceLocale(List<Locale> supportedLocales) {
    final deviceLocale = SchedulerBinding.instance.platformDispatcher.locale;
    return matchLocale(deviceLocale, supportedLocales);
  }

  void initializeLocale(List<Locale> supportedLocales) {
    final detectedLocale = detectDeviceLocale(supportedLocales);
    _locale = detectedLocale;
    notifyListeners();
  }
}
