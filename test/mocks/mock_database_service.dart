import 'package:deptsandloans/core/database/database_service.dart';
import 'package:isar_community/isar.dart';

class MockDatabaseService implements DatabaseService {
  final bool _isInitialized;

  MockDatabaseService({required bool isInitialized})
      : _isInitialized = isInitialized;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Isar get instance => throw UnimplementedError();

  @override
  Future<bool> close() => throw UnimplementedError();

  @override
  Future<Isar> initialize() => throw UnimplementedError();
}
