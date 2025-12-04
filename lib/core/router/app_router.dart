import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/reminder_repository.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/presentation/screens/main_screen.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:deptsandloans/presentation/screens/transaction_form/transaction_form_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({required TransactionRepository transactionRepository, required RepaymentRepository repaymentRepository, required ReminderRepository reminderRepository}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return MainScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository);
        },
      ),
      GoRoute(
        path: '/transaction/new',
        name: 'transaction-new',
        builder: (context, state) {
          final typeParam = state.uri.queryParameters['type'];
          final type = typeParam == 'loan' ? TransactionType.loan : TransactionType.debt;

          return TransactionFormScreen(transactionRepository: transactionRepository, reminderRepository: reminderRepository, type: type);
        },
      ),
      GoRoute(
        path: '/transaction/:id',
        name: 'transaction-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailsScreen(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository, transactionId: id);
        },
      ),
      GoRoute(
        path: '/transaction/:id/edit',
        name: 'transaction-edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final typeParam = state.uri.queryParameters['type'];
          final type = typeParam == 'loan' ? TransactionType.loan : TransactionType.debt;
          return TransactionFormScreen(transactionRepository: transactionRepository, reminderRepository: reminderRepository, type: type, transactionId: id);
        },
      ),
    ],
  );
}
