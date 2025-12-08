import 'dart:developer' as developer;
import 'package:deptsandloans/core/notifications/notification_scheduler.dart';
import 'package:deptsandloans/core/utils/SupportedLocale.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/repositories/reminder_repository.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';

class RecurringReminderProcessor {
  final ReminderRepository _reminderRepository;
  final RepaymentRepository _repaymentRepository;
  final TransactionRepository _transactionRepository;
  final NotificationScheduler _notificationScheduler;

  const RecurringReminderProcessor({
    required ReminderRepository reminderRepository,
    required RepaymentRepository repaymentRepository,
    required TransactionRepository transactionRepository,
    required NotificationScheduler notificationScheduler,
  }) : _reminderRepository = reminderRepository,
       _repaymentRepository = repaymentRepository,
       _transactionRepository = transactionRepository,
       _notificationScheduler = notificationScheduler;

  Future<void> processActiveRecurringReminders() async {
    try {
      final activeReminders = await _reminderRepository.getActiveReminders();
      final recurringReminders = activeReminders.where((r) => r.isRecurring).toList();

      developer.log('Processing ${recurringReminders.length} active recurring reminders', name: 'RecurringReminderProcessor');

      final locale = _getLocale();

      for (final reminder in recurringReminders) {
        await _processReminder(reminder, locale);
      }
    } catch (e, stackTrace) {
      developer.log('Failed to process active recurring reminders', name: 'RecurringReminderProcessor', level: 1000, error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _processReminder(Reminder reminder, String locale) async {
    try {
      final transaction = await _transactionRepository.getById(reminder.transactionId);

      if (transaction == null) {
        developer.log('Transaction not found for reminder ${reminder.id}', name: 'RecurringReminderProcessor', level: 900);
        return;
      }

      if (transaction.status == TransactionStatus.completed) {
        developer.log('Skipping reminder ${reminder.id} for completed transaction ${transaction.id}', name: 'RecurringReminderProcessor');
        return;
      }

      final repayments = await _repaymentRepository.getRepaymentsByTransactionId(transaction.id);
      final totalRepaid = repayments.fold<int>(0, (sum, rep) => sum + rep.amount);
      final remainingBalance = (transaction.amount - totalRepaid) / 100.0;

      final nextDate = reminder.nextReminderDate.add(Duration(days: reminder.intervalDays!));
      reminder.nextReminderDate = nextDate;

      final notificationId = await _notificationScheduler.scheduleRecurringReminder(
        reminder: reminder,
        transaction: transaction,
        locale: locale,
        remainingBalance: remainingBalance,
      );

      reminder.notificationId = notificationId;
      await _reminderRepository.updateReminder(reminder);

      developer.log('Rescheduled recurring reminder ${reminder.id} to $nextDate', name: 'RecurringReminderProcessor');
    } catch (e, stackTrace) {
      developer.log('Failed to process reminder ${reminder.id}', name: 'RecurringReminderProcessor', level: 1000, error: e, stackTrace: stackTrace);
    }
  }

  String _getLocale() {
    // TODO: Implement proper device locale detection
    // Consider extracting to a shared locale service or accepting as parameter
    return SupportedLocale.defaultLocale;
  }
}
