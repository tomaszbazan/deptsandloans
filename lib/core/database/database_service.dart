import 'dart:developer' as developer;
import 'package:deptsandloans/data/models/reminder.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static DatabaseService? _instance;
  Isar? _isar;

  DatabaseService._internal();

  factory DatabaseService() {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }

  Isar get instance {
    if (_isar == null) {
      throw StateError(
        'DatabaseService has not been initialized. '
        'Call initialize() before accessing the database instance.',
      );
    }
    return _isar!;
  }

  bool get isInitialized => _isar != null;

  Future<Isar> initialize() async {
    if (_isar != null) {
      developer.log('Database already initialized', name: 'DatabaseService');
      return _isar!;
    }

    try {
      developer.log('Initializing Isar database', name: 'DatabaseService');

      final dir = await getApplicationDocumentsDirectory();

      _isar = await Isar.open(
        [TransactionSchema, RepaymentSchema, ReminderSchema],
        directory: dir.path,
        name: 'deptsandloans',
      );

      developer.log('Isar database initialized successfully at ${dir.path}', name: 'DatabaseService');

      return _isar!;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to initialize database',
        name: 'DatabaseService',
        level: 1000,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> close() async {
    if (_isar == null) {
      developer.log('Database is not initialized, nothing to close', name: 'DatabaseService');
      return false;
    }

    try {
      developer.log('Closing database connection', name: 'DatabaseService');

      await _isar!.close();
      _isar = null;

      developer.log('Database closed successfully', name: 'DatabaseService');

      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to close database',
        name: 'DatabaseService',
        level: 1000, // SEVERE
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<void> reset() async {
    if (_instance != null && _instance!._isar != null) {
      await _instance!.close();
    }
    _instance = null;
  }
}
