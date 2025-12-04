// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Długi i Pożyczki';

  @override
  String get myDebts => 'Moje Długi';

  @override
  String get myLoans => 'Moje Pożyczki';

  @override
  String get name => 'Nazwa';

  @override
  String get amount => 'Kwota';

  @override
  String get currency => 'Waluta';

  @override
  String get description => 'Opis';

  @override
  String get dueDate => 'Termin płatności';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get add => 'Dodaj';

  @override
  String get addDebt => 'Dodaj Dług';

  @override
  String get addLoan => 'Dodaj Pożyczkę';

  @override
  String get editTransaction => 'Edytuj Transakcję';

  @override
  String get newTransaction => 'Nowa Transakcja';

  @override
  String get nameRequired => 'Nazwa jest wymagana';

  @override
  String get descriptionTooLong => 'Opis nie może być dłuższy niż 200 znaków';

  @override
  String get emptyDebts => 'Brak długów';

  @override
  String get emptyLoans => 'Brak pożyczek';

  @override
  String get addFirstDebt => 'Dodaj swój pierwszy dług, aby rozpocząć śledzenie';

  @override
  String get addFirstLoan => 'Dodaj swoją pierwszą pożyczkę, aby rozpocząć śledzenie';

  @override
  String get balance => 'Saldo';

  @override
  String get repayment => 'Spłata';

  @override
  String get addRepayment => 'Dodaj Spłatę';

  @override
  String get repaymentAmount => 'Kwota Spłaty';

  @override
  String get repaymentExceedsBalance => 'Kwota spłaty nie może przekroczyć pozostałego salda';

  @override
  String get completed => 'Zakończone';

  @override
  String get markAsCompleted => 'Oznacz jako Zakończone';

  @override
  String get archive => 'Archiwum';

  @override
  String get overdue => 'Przeterminowane';

  @override
  String get deleteConfirmation => 'Czy na pewno chcesz usunąć tę transakcję?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get reminder => 'Przypomnienie';

  @override
  String get setReminder => 'Ustaw Przypomnienie';

  @override
  String get oneTime => 'Jednorazowe';

  @override
  String get recurring => 'Cykliczne';

  @override
  String get reminderDate => 'Data Przypomnienia';

  @override
  String get intervalDays => 'Interwał (dni)';

  @override
  String get welcome => 'Witaj w Długach i Pożyczkach';

  @override
  String get databaseReady => 'Baza danych: Gotowa';

  @override
  String get databaseNotInitialized => 'Baza danych: Niezainicjalizowana';

  @override
  String get notSet => 'Nie ustawiono';

  @override
  String get optional => 'opcjonalne';

  @override
  String charactersRemaining(int count) {
    return 'Pozostało $count znaków';
  }

  @override
  String get amountRequired => 'Kwota jest wymagana';

  @override
  String get amountMustBePositive => 'Kwota musi być większa od zera';

  @override
  String get amountCannotBeChanged => 'Kwoty nie można zmienić po utworzeniu';

  @override
  String get repaymentHistory => 'Historia Spłat';

  @override
  String get noRepaymentsYet => 'Nie zarejestrowano jeszcze żadnych spłat';

  @override
  String get transactionFullyRepaid => 'Ta transakcja została w pełni spłacona';

  @override
  String get markAsCompletedConfirmTitle => 'Oznaczyć jako Zakończone?';

  @override
  String get markAsCompletedConfirmMessage => 'Ta akcja przeniesie transakcję do archiwum. Każde pozostałe saldo zostanie uznane za umorzone.';

  @override
  String get transactionMarkedCompleted => 'Transakcja oznaczona jako zakończona';

  @override
  String get failedToMarkCompleted => 'Nie udało się oznaczyć transakcji jako zakończonej';

  @override
  String get notificationReminderTitle => 'Przypomnienie o Płatności';

  @override
  String notificationDebtBody(String name, String amount) {
    return 'Przypomnienie: Zwróć $name - pozostało $amount';
  }

  @override
  String notificationLoanBody(String name, String amount) {
    return 'Przypomnienie: Odbierz od $name - pozostało $amount';
  }

  @override
  String get notificationChannelName => 'Przypomnienia o Długach i Pożyczkach';

  @override
  String get notificationChannelDescription => 'Powiadomienia o przypomnieniach dotyczących spłat długów i pożyczek';

  @override
  String get notificationPermissionTitle => 'Włącz Powiadomienia';

  @override
  String get notificationPermissionMessage => 'Zezwól na powiadomienia, aby otrzymywać przypomnienia o długach i pożyczkach o godzinie 19:00 każdego dnia.';

  @override
  String get notificationPermissionDenied => 'Odmówiono uprawnień do powiadomień. Możesz włączyć je w ustawieniach aplikacji.';

  @override
  String get openSettings => 'Otwórz Ustawienia';

  @override
  String get enableReminder => 'Włącz Przypomnienie';

  @override
  String get reminderType => 'Typ Przypomnienia';

  @override
  String get reminderDateRequired => 'Data przypomnienia jest wymagana';

  @override
  String get reminderDateMustBeFuture => 'Data przypomnienia musi być w przyszłości';

  @override
  String get intervalRequired => 'Interwał jest wymagany';

  @override
  String get intervalOutOfRange => 'Interwał musi wynosić od 1 do 365 dni';

  @override
  String get reminderTypeRequired => 'Proszę wybrać typ przypomnienia';

  @override
  String get days => 'dni';
}
