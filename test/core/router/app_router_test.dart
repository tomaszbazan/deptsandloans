import 'package:deptsandloans/core/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../mocks/mock_repayment_repository.dart';
import '../../mocks/mock_transaction_repository.dart';

void main() {
  late MockTransactionRepository transactionRepository;
  late MockRepaymentRepository repaymentRepository;
  late GoRouter router;

  setUp(() {
    transactionRepository = MockTransactionRepository();
    repaymentRepository = MockRepaymentRepository();
    router = createAppRouter(transactionRepository: transactionRepository, repaymentRepository: repaymentRepository);
  });

  group('AppRouter', () {
    test('has correct initial location configured', () {
      expect(router.configuration.routes.isNotEmpty, true);
    });

    test('defines home route', () {
      final route = router.configuration.routes.whereType<GoRoute>().firstWhere((r) => r.name == 'home');
      expect(route.path, '/');
    });

    test('defines transaction-new route', () {
      final route = router.configuration.routes.whereType<GoRoute>().firstWhere((r) => r.name == 'transaction-new');
      expect(route.path, '/transaction/new');
    });

    test('defines transaction-details route', () {
      final route = router.configuration.routes.whereType<GoRoute>().firstWhere((r) => r.name == 'transaction-details');
      expect(route.path, '/transaction/:id');
    });

    test('defines transaction-edit route', () {
      final route = router.configuration.routes.whereType<GoRoute>().firstWhere((r) => r.name == 'transaction-edit');
      expect(route.path, '/transaction/:id/edit');
    });

    test('has 4 routes configured', () {
      final routes = router.configuration.routes.whereType<GoRoute>();
      expect(routes.length, 4);
    });
  });
}
