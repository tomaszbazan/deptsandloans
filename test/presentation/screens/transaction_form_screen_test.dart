import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_notification_scheduler.dart';
import '../../mocks/mock_reminder_repository.dart';
import '../../mocks/mock_repayment_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  group('TransactionFormScreen', () {
    late TransactionRepository repository;
    late MockReminderRepository reminderRepository;
    late MockRepaymentRepository repaymentRepository;
    late MockNotificationScheduler notificationScheduler;

    setUp(() {
      repository = MockTransactionRepository();
      reminderRepository = MockReminderRepository();
      repaymentRepository = MockRepaymentRepository();
      notificationScheduler = MockNotificationScheduler();
    });

    testWidgets('displays new debt transaction mode correctly', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Debt'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays edit transaction mode correctly', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 456,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
    });

    testWidgets('displays loan type correctly', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.loan,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Loan'), findsOneWidget);
    });

    testWidgets('has all form fields', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
      expect(find.text('Description (optional)'), findsOneWidget);
      expect(find.text('Due Date (optional)'), findsOneWidget);
    });

    testWidgets('currency dropdown shows default PLN with symbol', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('zł'), findsOneWidget);
    });

    for (final currencyData in [
      {'symbol': '€', 'name': 'EUR'},
      {'symbol': '\$', 'name': 'USD'},
      {'symbol': '£', 'name': 'GBP'},
    ]) {
      testWidgets('can select ${currencyData['name']} currency from dropdown', (tester) async {
        await tester.pumpWidget(
          AppFixture.createDefaultApp(
            TransactionFormScreen(
              transactionRepository: repository,
              reminderRepository: reminderRepository,
              repaymentRepository: repaymentRepository,
              notificationScheduler: notificationScheduler,
              type: TransactionType.debt,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('zł'));
        await tester.pumpAndSettle();

        expect(find.text(currencyData['symbol']!), findsOneWidget);

        await tester.tap(find.text(currencyData['symbol']!).last);
        await tester.pumpAndSettle();

        expect(find.text(currencyData['symbol']!), findsOneWidget);
      });
    }

    testWidgets('date picker opens when tapping due date field', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Not set'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('shows validation error when name is empty and save is pressed', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '100');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('shows validation error when amount is zero', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test Debt');
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '0');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Amount must be greater than zero'), findsOneWidget);
    });

    testWidgets('clears validation error when valid input is entered', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Test Debt');
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsNothing);
    });

    testWidgets('shows multiple validation errors when fields are invalid', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });
  });

  group('TransactionFormScreen - Edit Mode', () {
    late MockTransactionRepository repository;
    late MockReminderRepository reminderRepository;
    late MockRepaymentRepository repaymentRepository;
    late MockNotificationScheduler notificationScheduler;

    setUp(() async {
      repository = MockTransactionRepository();
      reminderRepository = MockReminderRepository();
      repaymentRepository = MockRepaymentRepository();
      notificationScheduler = MockNotificationScheduler();
    });

    testWidgets('amount field is disabled in edit mode', (tester) async {
      await repository.create(TransactionFixture.createTransaction(id: 1, name: 'Test Debt'));

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final amountField = tester.widget<TextField>(find.widgetWithText(TextField, 'Amount'));
      expect(amountField.enabled, isFalse);
    });

    testWidgets('shows helper text for disabled amount field', (tester) async {
      await repository.create(TransactionFixture.createTransaction(id: 1, name: 'Test Debt'));

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Amount cannot be changed after creation'), findsOneWidget);
    });

    testWidgets('currency dropdown is disabled in edit mode', (tester) async {
      await repository.create(TransactionFixture.createTransaction(id: 1, name: 'Test Debt'));

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final currencyDropdown = tester.widget<DropdownButtonFormField<Currency>>(find.byType(DropdownButtonFormField<Currency>));
      expect(currencyDropdown.onChanged, isNull);
    });

    testWidgets('populates form fields with existing transaction data', (tester) async {
      final testDate = DateTime(2025, 12, 31);
      await repository.create(
        TransactionFixture.createTransaction(id: 1, name: 'Existing Debt', amount: 25000, currency: Currency.eur, description: 'Test description', dueDate: testDate),
      );

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Existing Debt'), findsOneWidget);
      expect(find.text('250.0'), findsOneWidget);
      expect(find.text('€'), findsOneWidget);
      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('can edit name field in edit mode', (tester) async {
      await repository.create(TransactionFixture.createTransaction(id: 1, name: 'Original Name'));

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          TransactionFormScreen(
            transactionRepository: repository,
            reminderRepository: reminderRepository,
            repaymentRepository: repaymentRepository,
            notificationScheduler: notificationScheduler,
            type: TransactionType.debt,
            transactionId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final nameField = tester.widget<TextField>(find.widgetWithText(TextField, 'Name'));
      expect(nameField.enabled, isNull);

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Updated Name');
      await tester.pumpAndSettle();

      expect(find.text('Updated Name'), findsOneWidget);
    });
  });
}
