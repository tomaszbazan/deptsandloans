import 'package:flutter_test/flutter_test.dart';
import 'package:deptsandloans/core/database/database_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DatabaseService', () {
    setUp(() async {
      await DatabaseService.reset();
    });

    tearDown(() async {
      await DatabaseService.reset();
    });

    test('should create singleton instance', () {
      final instance1 = DatabaseService();
      final instance2 = DatabaseService();

      expect(instance1, equals(instance2));
    });

    test('should throw StateError when accessing instance before initialization', () {
      final databaseService = DatabaseService();

      expect(() => databaseService.instance, throwsA(isA<StateError>()));
    });

    test('should return false when closing uninitialized database', () async {
      final databaseService = DatabaseService();

      final closed = await databaseService.close();

      expect(closed, isFalse);
    });

    test('isInitialized should return false before initialization', () {
      final databaseService = DatabaseService();

      expect(databaseService.isInitialized, isFalse);
    });
  });
}
