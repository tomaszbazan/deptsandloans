// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Debts and Loans';

  @override
  String get myDebts => 'My Debts';

  @override
  String get myLoans => 'My Loans';

  @override
  String get name => 'Name';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get description => 'Description';

  @override
  String get dueDate => 'Due Date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get addDebt => 'Add Debt';

  @override
  String get addLoan => 'Add Loan';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get descriptionTooLong => 'Description must be 200 characters or less';

  @override
  String get emptyDebts => 'No debts yet';

  @override
  String get emptyLoans => 'No loans yet';

  @override
  String get addFirstDebt => 'Add your first debt to start tracking';

  @override
  String get addFirstLoan => 'Add your first loan to start tracking';

  @override
  String get balance => 'Balance';

  @override
  String get repayment => 'Repayment';

  @override
  String get addRepayment => 'Add Repayment';

  @override
  String get repaymentAmount => 'Repayment Amount';

  @override
  String get repaymentExceedsBalance => 'Repayment amount cannot exceed remaining balance';

  @override
  String get completed => 'Completed';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get archive => 'Archive';

  @override
  String get overdue => 'Overdue';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this transaction?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get reminder => 'Reminder';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get oneTime => 'One-time';

  @override
  String get recurring => 'Recurring';

  @override
  String get reminderDate => 'Reminder Date';

  @override
  String get intervalDays => 'Interval (days)';

  @override
  String get welcome => 'Welcome to Debts and Loans';

  @override
  String get databaseReady => 'Database: Ready';

  @override
  String get databaseNotInitialized => 'Database: Not initialized';

  @override
  String get notSet => 'Not set';

  @override
  String get optional => 'optional';

  @override
  String charactersRemaining(int count) {
    return '$count characters remaining';
  }

  @override
  String get amountRequired => 'Amount is required';

  @override
  String get amountMustBePositive => 'Amount must be greater than zero';

  @override
  String get amountCannotBeChanged => 'Amount cannot be changed after creation';

  @override
  String get repaymentHistory => 'Repayment History';

  @override
  String get noRepaymentsYet => 'No repayments recorded yet';

  @override
  String get transactionFullyRepaid => 'This transaction has been fully repaid';

  @override
  String get markAsCompletedConfirmTitle => 'Mark as Completed?';

  @override
  String get markAsCompletedConfirmMessage => 'This action will move the transaction to archive. Any remaining balance will be considered forgiven.';

  @override
  String get transactionMarkedCompleted => 'Transaction marked as completed';

  @override
  String get failedToMarkCompleted => 'Failed to mark transaction as completed';

  @override
  String get notificationReminderTitle => 'Payment Reminder';

  @override
  String notificationDebtBody(String name, String amount) {
    return 'Reminder: Pay back $name - $amount remaining';
  }

  @override
  String notificationLoanBody(String name, String amount) {
    return 'Reminder: Collect from $name - $amount remaining';
  }

  @override
  String get notificationChannelName => 'Debt and Loan Reminders';

  @override
  String get notificationChannelDescription => 'Notifications for debt and loan payment reminders';

  @override
  String get notificationPermissionTitle => 'Enable Notifications';

  @override
  String get notificationPermissionMessage => 'Allow notifications to receive reminders for your debts and loans at 19:00 each day.';

  @override
  String get notificationPermissionDenied => 'Notification permission denied. You can enable it in app settings.';

  @override
  String get openSettings => 'Open Settings';
}
