import 'package:deptsandloans/core/database/database_service.dart';

class MockDatabaseService implements DatabaseService {
  final bool _isInitialized;

  MockDatabaseService({bool isInitialized = true})
      : _isInitialized = isInitialized;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  bool get isInitialized => _isInitialized;
}
