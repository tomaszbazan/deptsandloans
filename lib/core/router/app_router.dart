import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'package:deptsandloans/presentation/screens/transaction_details_screen.dart';
import 'package:deptsandloans/presentation/screens/transaction_form_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(DatabaseService databaseService) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(databaseService: databaseService),
      ),
      GoRoute(
        path: '/transaction/new',
        name: 'transaction-new',
        builder: (context, state) {
          final transactionType = state.uri.queryParameters['type'];
          return TransactionFormScreen(
            databaseService: databaseService,
            transactionType: transactionType,
          );
        },
      ),
      GoRoute(
        path: '/transaction/:id',
        name: 'transaction-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailsScreen(
            databaseService: databaseService,
            transactionId: id,
          );
        },
      ),
      GoRoute(
        path: '/transaction/:id/edit',
        name: 'transaction-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionFormScreen(
            databaseService: databaseService,
            transactionId: id,
          );
        },
      ),
    ],
  );
}
