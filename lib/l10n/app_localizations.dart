import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('pl')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Debts and Loans'**
  String get appTitle;

  /// Tab name for debts list
  ///
  /// In en, this message translates to:
  /// **'My Debts'**
  String get myDebts;

  /// Tab name for loans list
  ///
  /// In en, this message translates to:
  /// **'My Loans'**
  String get myLoans;

  /// Label for name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for amount field
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Label for currency field
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Label for description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for due date field
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Button label for adding a new debt
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebt;

  /// Button label for adding a new loan
  ///
  /// In en, this message translates to:
  /// **'Add Loan'**
  String get addLoan;

  /// Screen title for editing a transaction
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// Screen title for creating a new transaction
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransaction;

  /// Validation message for required name field
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Validation message for description field exceeding max length
  ///
  /// In en, this message translates to:
  /// **'Description must be 200 characters or less'**
  String get descriptionTooLong;

  /// Empty state message for debts list
  ///
  /// In en, this message translates to:
  /// **'No debts yet'**
  String get emptyDebts;

  /// Empty state message for loans list
  ///
  /// In en, this message translates to:
  /// **'No loans yet'**
  String get emptyLoans;

  /// Empty state suggestion for debts
  ///
  /// In en, this message translates to:
  /// **'Add your first debt to start tracking'**
  String get addFirstDebt;

  /// Empty state suggestion for loans
  ///
  /// In en, this message translates to:
  /// **'Add your first loan to start tracking'**
  String get addFirstLoan;

  /// Label for remaining balance
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Label for repayment
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get repayment;

  /// Button label for adding a repayment
  ///
  /// In en, this message translates to:
  /// **'Add Repayment'**
  String get addRepayment;

  /// Label for repayment amount field
  ///
  /// In en, this message translates to:
  /// **'Repayment Amount'**
  String get repaymentAmount;

  /// Validation message for repayment exceeding balance
  ///
  /// In en, this message translates to:
  /// **'Repayment amount cannot exceed remaining balance'**
  String get repaymentExceedsBalance;

  /// Label for completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Button label for marking transaction as completed
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// Label for archive section
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// Label for overdue transactions
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// Confirmation message for deleting a transaction
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteConfirmation;

  /// Affirmative answer
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative answer
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Label for reminder
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// Button label for setting a reminder
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// Label for one-time reminder
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get oneTime;

  /// Label for recurring reminder
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// Label for reminder date field
  ///
  /// In en, this message translates to:
  /// **'Reminder Date'**
  String get reminderDate;

  /// Label for reminder interval in days
  ///
  /// In en, this message translates to:
  /// **'Interval (days)'**
  String get intervalDays;

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Debts and Loans'**
  String get welcome;

  /// Message when database is initialized
  ///
  /// In en, this message translates to:
  /// **'Database: Ready'**
  String get databaseReady;

  /// Message when database is not initialized
  ///
  /// In en, this message translates to:
  /// **'Database: Not initialized'**
  String get databaseNotInitialized;

  /// Label for optional fields that have no value
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Label suffix for optional fields
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// Character count helper text for description field
  ///
  /// In en, this message translates to:
  /// **'{count} characters remaining'**
  String charactersRemaining(int count);

  /// Validation message for required amount field
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// Validation message for positive amount
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountMustBePositive;

  /// Helper text for disabled amount field in edit mode
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be changed after creation'**
  String get amountCannotBeChanged;

  /// Title for repayment history section
  ///
  /// In en, this message translates to:
  /// **'Repayment History'**
  String get repaymentHistory;

  /// Empty state message for repayment history
  ///
  /// In en, this message translates to:
  /// **'No repayments recorded yet'**
  String get noRepaymentsYet;

  /// Message shown when trying to add repayment to fully repaid transaction
  ///
  /// In en, this message translates to:
  /// **'This transaction has been fully repaid'**
  String get transactionFullyRepaid;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
