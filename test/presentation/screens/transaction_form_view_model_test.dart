import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_reminder_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  group('TransactionFormViewModel', () {
    late TransactionRepository repository;
    late MockReminderRepository reminderRepository;
    late TransactionFormViewModel viewModel;

    setUp(() {
      repository = MockTransactionRepository();
      reminderRepository = MockReminderRepository();
      viewModel = TransactionFormViewModel(repository: repository, reminderRepository: reminderRepository, type: TransactionType.debt);
    });

    group('initial state', () {
      test('has correct default values', () {
        expect(viewModel.name, '');
        expect(viewModel.amount, null);
        expect(viewModel.currency, Currency.pln);
        expect(viewModel.description, null);
        expect(viewModel.dueDate, null);
        expect(viewModel.isLoading, false);
        expect(viewModel.errorMessage, null);
        expect(viewModel.nameError, null);
        expect(viewModel.descriptionError, null);
        expect(viewModel.amountError, null);
        expect(viewModel.type, TransactionType.debt);
        expect(viewModel.isEditMode, false);
      });
    });

    group('setName', () {
      test('updates name and clears error when valid', () {
        viewModel.setName('Test Name');

        expect(viewModel.name, 'Test Name');
        expect(viewModel.nameError, null);
      });

      test('sets error when name is empty', () {
        viewModel.setName('');

        expect(viewModel.name, '');
        expect(viewModel.nameError, 'nameRequired');
      });

      test('sets error when name is only whitespace', () {
        viewModel.setName('   ');

        expect(viewModel.name, '   ');
        expect(viewModel.nameError, 'nameRequired');
      });
    });

    group('setAmount', () {
      test('updates amount and clears error when valid', () {
        viewModel.setAmount(100.50);

        expect(viewModel.amount, 100.50);
        expect(viewModel.amountError, null);
      });

      test('sets error when amount is null', () {
        viewModel.setAmount(null);

        expect(viewModel.amount, null);
        expect(viewModel.amountError, 'amountRequired');
      });

      test('sets error when amount is zero', () {
        viewModel.setAmount(0);

        expect(viewModel.amount, 0);
        expect(viewModel.amountError, 'amountMustBePositive');
      });

      test('sets error when amount is negative', () {
        viewModel.setAmount(-10);

        expect(viewModel.amount, -10);
        expect(viewModel.amountError, 'amountMustBePositive');
      });
    });

    group('setCurrency', () {
      test('updates currency', () {
        viewModel.setCurrency(Currency.eur);

        expect(viewModel.currency, Currency.eur);
      });
    });

    group('setDescription', () {
      test('updates description when valid', () {
        viewModel.setDescription('Test description');

        expect(viewModel.description, 'Test description');
        expect(viewModel.descriptionError, null);
      });

      test('sets description to null when empty', () {
        viewModel.setDescription('');

        expect(viewModel.description, null);
        expect(viewModel.descriptionError, null);
      });

      test('sets description to null when null', () {
        viewModel.setDescription(null);

        expect(viewModel.description, null);
        expect(viewModel.descriptionError, null);
      });

      test('sets error when description exceeds 200 characters', () {
        final longDescription = 'a' * 201;
        viewModel.setDescription(longDescription);

        expect(viewModel.description, longDescription);
        expect(viewModel.descriptionError, 'descriptionTooLong');
      });

      test('accepts description with exactly 200 characters', () {
        final description = 'a' * 200;
        viewModel.setDescription(description);

        expect(viewModel.description, description);
        expect(viewModel.descriptionError, null);
      });
    });

    group('setDueDate', () {
      test('updates due date', () {
        final date = DateTime(2025, 12, 31);
        viewModel.setDueDate(date);

        expect(viewModel.dueDate, date);
      });

      test('can clear due date', () {
        viewModel.setDueDate(DateTime(2025, 12, 31));
        viewModel.setDueDate(null);

        expect(viewModel.dueDate, null);
      });
    });

    group('validateForm', () {
      test('returns false when name is empty', () {
        viewModel.setAmount(100);

        final result = viewModel.validateForm();

        expect(result, false);
        expect(viewModel.nameError, 'nameRequired');
      });

      test('returns false when amount is null', () {
        viewModel.setName('Test Name');

        final result = viewModel.validateForm();

        expect(result, false);
        expect(viewModel.amountError, 'amountRequired');
      });

      test('returns false when amount is zero', () {
        viewModel.setName('Test Name');
        viewModel.setAmount(0);

        final result = viewModel.validateForm();

        expect(result, false);
        expect(viewModel.amountError, 'amountMustBePositive');
      });

      test('returns false when description is too long', () {
        viewModel.setName('Test Name');
        viewModel.setAmount(100);
        viewModel.setDescription('a' * 201);

        final result = viewModel.validateForm();

        expect(result, false);
        expect(viewModel.descriptionError, 'descriptionTooLong');
      });

      test('returns true when all fields are valid', () {
        viewModel.setName('Test Name');
        viewModel.setAmount(100);

        final result = viewModel.validateForm();

        expect(result, true);
        expect(viewModel.nameError, null);
        expect(viewModel.amountError, null);
        expect(viewModel.descriptionError, null);
      });

      test('returns true when optional fields are not set', () {
        viewModel.setName('Test Name');
        viewModel.setAmount(100);

        final result = viewModel.validateForm();

        expect(result, true);
      });
    });

    group('saveTransaction', () {
      test('returns false when validation fails', () async {
        final result = await viewModel.saveTransaction();

        expect(result, false);
        expect(viewModel.isLoading, false);
      });

      test('saves transaction successfully when valid', () async {
        viewModel.setName('Test Debt');
        viewModel.setAmount(100.50);
        viewModel.setCurrency(Currency.pln);

        final result = await viewModel.saveTransaction();

        expect(result, true);
        expect(viewModel.isLoading, false);
        expect(viewModel.errorMessage, null);

        final transactions = await repository.getByType(TransactionType.debt);
        expect(transactions.length, 1);
        expect(transactions[0].name, 'Test Debt');
        expect(transactions[0].amount, 10050);
        expect(transactions[0].currency, Currency.pln);
        expect(transactions[0].type, TransactionType.debt);
        expect(transactions[0].status, TransactionStatus.active);
      });

      test('saves transaction with all fields', () async {
        final dueDate = DateTime(2025, 12, 31);
        viewModel.setName('Test Debt');
        viewModel.setAmount(100.50);
        viewModel.setCurrency(Currency.eur);
        viewModel.setDescription('Test description');
        viewModel.setDueDate(dueDate);

        final result = await viewModel.saveTransaction();

        expect(result, true);

        final transactions = await repository.getByType(TransactionType.debt);
        expect(transactions.length, 1);
        expect(transactions[0].name, 'Test Debt');
        expect(transactions[0].amount, 10050);
        expect(transactions[0].currency, Currency.eur);
        expect(transactions[0].description, 'Test description');
        expect(transactions[0].dueDate, dueDate);
      });

      test('converts amount to cents correctly', () async {
        viewModel.setName('Test Debt');
        viewModel.setAmount(99.99);

        await viewModel.saveTransaction();

        final transactions = await repository.getByType(TransactionType.debt);
        expect(transactions[0].amount, 9999);
        expect(transactions[0].amountInMainUnit, 99.99);
      });

      test('sets loading state during save', () async {
        viewModel.setName('Test Debt');
        viewModel.setAmount(100);

        expect(viewModel.isLoading, false);

        var loadingStateWasTrue = false;
        viewModel.addListener(() {
          if (viewModel.isLoading) {
            loadingStateWasTrue = true;
          }
        });

        await viewModel.saveTransaction();

        expect(loadingStateWasTrue, true);
        expect(viewModel.isLoading, false);
      });

      test('creates loan type transaction correctly', () async {
        final loanViewModel = TransactionFormViewModel(repository: repository, reminderRepository: reminderRepository, type: TransactionType.loan);

        loanViewModel.setName('Test Loan');
        loanViewModel.setAmount(200);

        await loanViewModel.saveTransaction();

        final transactions = await repository.getByType(TransactionType.loan);
        expect(transactions.length, 1);
        expect(transactions[0].type, TransactionType.loan);
      });

      test('saves transaction without optional fields', () async {
        viewModel.setName('Test Debt');
        viewModel.setAmount(100);

        final result = await viewModel.saveTransaction();

        expect(result, true);

        final transactions = await repository.getByType(TransactionType.debt);
        expect(transactions[0].description, null);
        expect(transactions[0].dueDate, null);
      });
    });
  });
}
