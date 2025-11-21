import 'package:deptsandloans/core/database/database_service.dart';

class MockDatabaseService implements DatabaseService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  bool get isInitialized => true;
}
