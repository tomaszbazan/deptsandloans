import 'package:deptsandloans/core/database/database_service.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

Future<void> initializeTestIsar() async {
  await Isar.initializeIsarCore(download: true);
}

MockDatabaseService createMockDatabaseService() {
  // final testDbDir = Directory('build/test_db');
  // if (!testDbDir.existsSync()) {
  //   testDbDir.createSync(recursive: true);
  // }
  //
  // final isar = Isar.openSync([TransactionSchema, RepaymentSchema, ReminderSchema], directory: testDbDir.path, name: 'test_${DateTime.now().millisecondsSinceEpoch}');

  final mock = MockDatabaseService();
  when(() => mock.isInitialized).thenReturn(true);
  // when(() => mock.instance).thenReturn(Isar.);
  return mock;
}
