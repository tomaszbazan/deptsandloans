import 'package:deptsandloans/core/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../mocks/mock_database_service.dart';

void main() {
  late MockDatabaseService databaseService;
  late GoRouter router;

  setUp(() {
    databaseService = createMockDatabaseService();
    router = createAppRouter(databaseService);
  });

  group('AppRouter', () {
    test('has correct initial location configured', () {
      expect(router.configuration.routes.isNotEmpty, true);
    });

    test('defines home route', () {
      final route = router.configuration.routes
          .whereType<GoRoute>()
          .firstWhere((r) => r.name == 'home');
      expect(route.path, '/');
    });

    test('defines transaction-new route', () {
      final route = router.configuration.routes
          .whereType<GoRoute>()
          .firstWhere((r) => r.name == 'transaction-new');
      expect(route.path, '/transaction/new');
    });

    test('defines transaction-details route', () {
      final route = router.configuration.routes
          .whereType<GoRoute>()
          .firstWhere((r) => r.name == 'transaction-details');
      expect(route.path, '/transaction/:id');
    });

    test('defines transaction-edit route', () {
      final route = router.configuration.routes
          .whereType<GoRoute>()
          .firstWhere((r) => r.name == 'transaction-edit');
      expect(route.path, '/transaction/:id/edit');
    });

    test('has 4 routes configured', () {
      final routes = router.configuration.routes.whereType<GoRoute>();
      expect(routes.length, 4);
    });
  });

}
