import 'package:deptsandloans/core/notifications/notification_scheduler.dart';
import 'package:deptsandloans/core/notifications/recurring_reminder_processor.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/reminder_repository.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockRepaymentRepository extends Mock implements RepaymentRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockNotificationScheduler extends Mock implements NotificationScheduler {}

void main() {
  late MockReminderRepository mockReminderRepository;
  late MockRepaymentRepository mockRepaymentRepository;
  late MockTransactionRepository mockTransactionRepository;
  late MockNotificationScheduler mockNotificationScheduler;
  late RecurringReminderProcessor processor;

  setUp(() {
    mockReminderRepository = MockReminderRepository();
    mockRepaymentRepository = MockRepaymentRepository();
    mockTransactionRepository = MockTransactionRepository();
    mockNotificationScheduler = MockNotificationScheduler();
    processor = RecurringReminderProcessor(
      reminderRepository: mockReminderRepository,
      repaymentRepository: mockRepaymentRepository,
      transactionRepository: mockTransactionRepository,
      notificationScheduler: mockNotificationScheduler,
    );
  });

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(
      Reminder()
        ..id = 1
        ..transactionId = 1
        ..type = ReminderType.recurring
        ..intervalDays = 7
        ..nextReminderDate = DateTime.now()
        ..createdAt = DateTime.now(),
    );
    registerFallbackValue(
      Transaction()
        ..id = 1
        ..type = TransactionType.debt
        ..name = 'Test'
        ..amount = 10000
        ..currency = Currency.pln
        ..status = TransactionStatus.active
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    );
  });

  group('RecurringReminderProcessor', () {
    group('processActiveRecurringReminders', () {
      test('should reschedule active recurring reminders', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder]);
        when(() => mockTransactionRepository.getById(42)).thenAnswer((_) async => transaction);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(42)).thenAnswer((_) async => []);
        when(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        ).thenAnswer((_) async => 1042);
        when(() => mockReminderRepository.updateReminder(any())).thenAnswer((_) async => {});

        await processor.processActiveRecurringReminders();

        verify(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: transaction,
            locale: 'en',
            remainingBalance: 100.0,
          ),
        ).called(1);
        verify(() => mockReminderRepository.updateReminder(any())).called(1);
      });

      test('should skip completed transactions', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.completed
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder]);
        when(() => mockTransactionRepository.getById(42)).thenAnswer((_) async => transaction);

        await processor.processActiveRecurringReminders();

        verifyNever(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        );
        verifyNever(() => mockReminderRepository.updateReminder(any()));
      });

      test('should handle multiple active reminders', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final reminder1 = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final reminder2 = Reminder()
          ..id = 2
          ..transactionId = 43
          ..type = ReminderType.recurring
          ..intervalDays = 14
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final reminder3 = Reminder()
          ..id = 3
          ..transactionId = 44
          ..type = ReminderType.recurring
          ..intervalDays = 30
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final transaction1 = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt 1'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        final transaction2 = Transaction()
          ..id = 43
          ..type = TransactionType.loan
          ..name = 'Test Loan 1'
          ..amount = 20000
          ..currency = Currency.usd
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        final transaction3 = Transaction()
          ..id = 44
          ..type = TransactionType.debt
          ..name = 'Test Debt 2'
          ..amount = 15000
          ..currency = Currency.eur
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder1, reminder2, reminder3]);
        when(() => mockTransactionRepository.getById(42)).thenAnswer((_) async => transaction1);
        when(() => mockTransactionRepository.getById(43)).thenAnswer((_) async => transaction2);
        when(() => mockTransactionRepository.getById(44)).thenAnswer((_) async => transaction3);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(42)).thenAnswer((_) async => []);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(43)).thenAnswer((_) async => []);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(44)).thenAnswer((_) async => []);
        when(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        ).thenAnswer((_) async => 1000);
        when(() => mockReminderRepository.updateReminder(any())).thenAnswer((_) async => {});

        await processor.processActiveRecurringReminders();

        verify(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        ).called(3);
        verify(() => mockReminderRepository.updateReminder(any())).called(3);
      });

      test('should calculate correct remaining balance with repayments', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        final repayment = Repayment()
          ..id = 1
          ..transactionId = 42
          ..amount = 3000
          ..when = DateTime.now()
          ..createdAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder]);
        when(() => mockTransactionRepository.getById(42)).thenAnswer((_) async => transaction);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(42)).thenAnswer((_) async => [repayment]);
        when(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        ).thenAnswer((_) async => 1042);
        when(() => mockReminderRepository.updateReminder(any())).thenAnswer((_) async => {});

        await processor.processActiveRecurringReminders();

        verify(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: transaction,
            locale: 'en',
            remainingBalance: 70.0,
          ),
        ).called(1);
      });

      test('should skip one-time reminders', () async {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.oneTime
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder]);

        await processor.processActiveRecurringReminders();

        verifyNever(() => mockTransactionRepository.getById(any()));
        verifyNever(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        );
      });

      test('should update nextReminderDate by intervalDays', () async {
        final yesterday = DateTime(2025, 12, 1);
        final reminder = Reminder()
          ..id = 1
          ..transactionId = 42
          ..type = ReminderType.recurring
          ..intervalDays = 7
          ..nextReminderDate = yesterday
          ..createdAt = DateTime.now();

        final transaction = Transaction()
          ..id = 42
          ..type = TransactionType.debt
          ..name = 'Test Debt'
          ..amount = 10000
          ..currency = Currency.pln
          ..status = TransactionStatus.active
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        when(() => mockReminderRepository.getActiveReminders()).thenAnswer((_) async => [reminder]);
        when(() => mockTransactionRepository.getById(42)).thenAnswer((_) async => transaction);
        when(() => mockRepaymentRepository.getRepaymentsByTransactionId(42)).thenAnswer((_) async => []);
        when(
          () => mockNotificationScheduler.scheduleRecurringReminder(
            reminder: any(named: 'reminder'),
            transaction: any(named: 'transaction'),
            locale: any(named: 'locale'),
            remainingBalance: any(named: 'remainingBalance'),
          ),
        ).thenAnswer((_) async => 1042);
        when(() => mockReminderRepository.updateReminder(any())).thenAnswer((_) async => {});

        await processor.processActiveRecurringReminders();

        final capturedReminderFromScheduler =
            verify(
                  () => mockNotificationScheduler.scheduleRecurringReminder(
                    reminder: captureAny(named: 'reminder'),
                    transaction: any(named: 'transaction'),
                    locale: any(named: 'locale'),
                    remainingBalance: any(named: 'remainingBalance'),
                  ),
                ).captured.single
                as Reminder;
        expect(capturedReminderFromScheduler.nextReminderDate, equals(DateTime(2025, 12, 8)));

        final capturedReminderFromUpdate = verify(() => mockReminderRepository.updateReminder(captureAny())).captured.single as Reminder;
        expect(capturedReminderFromUpdate.nextReminderDate, equals(DateTime(2025, 12, 8)));
      });
    });
  });
}
