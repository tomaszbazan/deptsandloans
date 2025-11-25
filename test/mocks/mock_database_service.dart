import 'package:deptsandloans/core/database/database_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

MockDatabaseService createMockDatabaseService() {
  final mock = MockDatabaseService();
  when(() => mock.isInitialized).thenReturn(true);
  return mock;
}
