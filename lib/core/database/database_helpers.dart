import 'dart:developer' as developer;

import 'package:isar_community/isar.dart';

class DatabaseException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  DatabaseException(this.message, {this.originalError, this.stackTrace});

  @override
  String toString() {
    if (originalError != null) {
      return 'DatabaseException: $message\nCaused by: $originalError';
    }
    return 'DatabaseException: $message';
  }
}

Future<T> executeDatabaseOperation<T>(String operationName, Future<T> Function() operation) async {
  try {
    developer.log('Executing database operation: $operationName', name: 'DatabaseHelpers');

    final result = await operation();

    developer.log('Database operation completed: $operationName', name: 'DatabaseHelpers');

    return result;
  } catch (e, stackTrace) {
    developer.log(
      'Database operation failed: $operationName',
      name: 'DatabaseHelpers',
      level: 1000, // SEVERE
      error: e,
      stackTrace: stackTrace,
    );

    throw DatabaseException('Failed to execute database operation: $operationName', originalError: e, stackTrace: stackTrace);
  }
}

Future<T> executeTransaction<T>(Isar isar, Future<T> Function(Isar isar) operation) async {
  try {
    developer.log('Starting database transaction', name: 'DatabaseHelpers');

    final result = await isar.writeTxn(() => operation(isar));

    developer.log('Database transaction completed successfully', name: 'DatabaseHelpers');

    return result;
  } catch (e, stackTrace) {
    developer.log(
      'Database transaction failed and was rolled back',
      name: 'DatabaseHelpers',
      level: 1000, // SEVERE
      error: e,
      stackTrace: stackTrace,
    );

    throw DatabaseException('Transaction failed and was rolled back', originalError: e, stackTrace: stackTrace);
  }
}

Future<void> executeBatchOperation(Isar isar, Future<void> Function(Isar isar) operation) async {
  try {
    developer.log('Starting batch database operation', name: 'DatabaseHelpers');

    await isar.writeTxn(() => operation(isar));

    developer.log('Batch operation completed successfully', name: 'DatabaseHelpers');
  } catch (e, stackTrace) {
    developer.log(
      'Batch operation failed',
      name: 'DatabaseHelpers',
      level: 1000, // SEVERE
      error: e,
      stackTrace: stackTrace,
    );

    throw DatabaseException('Batch operation failed', originalError: e, stackTrace: stackTrace);
  }
}

class DatabaseMigrationHelper {
  static bool isMigrationNeeded(int currentVersion, int storedVersion) {
    return currentVersion != storedVersion;
  }

  static void logMigrationStart(int fromVersion, int toVersion) {
    developer.log('Starting database migration from version $fromVersion to $toVersion', name: 'DatabaseMigration');
  }

  static void logMigrationComplete(int version) {
    developer.log('Database migration completed successfully to version $version', name: 'DatabaseMigration');
  }

  static void logMigrationFailure(int fromVersion, int toVersion, dynamic error) {
    developer.log(
      'Database migration failed from version $fromVersion to $toVersion',
      name: 'DatabaseMigration',
      level: 1000, // SEVERE
      error: error,
    );
  }
}
