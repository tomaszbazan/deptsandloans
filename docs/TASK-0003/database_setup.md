# Database Setup Documentation

## Overview

This document provides comprehensive information about the database setup for the Debts and Loans application. The application uses **Isar Community** as its local-first database solution for storing transaction data, repayments, and reminders.

**Note:** The project has been migrated from the original `isar` package to `isar_community`, which is actively maintained and developed. See the [Migration to isar_community](#migration-to-isar_community) section for details.

## Technology Stack

- **Database:** isar_community 3.3.0
- **Platform Support:** isar_community_flutter_libs 3.3.0
- **Path Provider:** path_provider 2.1.5 (for getting application documents directory)
- **Code Generation:** isar_community_generator 3.3.0, build_runner 2.7.1

## Architecture

### Database Service Layer

The database is managed through a singleton `DatabaseService` class located at:
```
lib/core/database/database_service.dart
```

#### Key Features:
- **Singleton Pattern:** Ensures only one database instance exists
- **Lifecycle Management:** Handles database initialization and cleanup
- **Error Handling:** Comprehensive logging and error reporting
- **Type Safety:** Full Dart type safety with compile-time checks

### File Structure

```
lib/
└── core/
    └── database/
        ├── database_service.dart      # Main database service
        └── database_helpers.dart      # Helper utilities

test/
└── core/
    └── database/
        └── database_service_test.dart # Unit tests
```

## Installation

### Dependencies

The following dependencies are already added to `pubspec.yaml`:

```yaml
dependencies:
  isar_community: ^3.3.0
  isar_community_flutter_libs: ^3.3.0
  path_provider: ^2.1.5

dev_dependencies:
  isar_community_generator: ^3.3.0
  build_runner: ^2.7.1
```

### Installing Packages

To install the packages, run:

```bash
flutter pub get
```

## Usage

### Initializing the Database

The database is initialized in `main.dart` before the app starts:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final databaseService = DatabaseService();
    await databaseService.initialize();

    runApp(DeptsAndLoansApp(databaseService: databaseService));
  } catch (e, stackTrace) {
    // Error handling
  }
}
```

### Accessing the Database

To access the database instance in your code:

```dart
final databaseService = DatabaseService();
final isar = databaseService.instance;

// Now you can use isar to perform database operations
```

### Database Operations

#### Using Helper Functions

The `database_helpers.dart` file provides utility functions for common operations:

1. **Execute Database Operation:**
```dart
final result = await executeDatabaseOperation(
  'fetch transactions',
  () => isar.transactions.where().findAll(),
);
```

2. **Execute Transaction:**
```dart
await executeTransaction(isar, (isar) async {
  await isar.transactions.put(transaction1);
  await isar.transactions.put(transaction2);
});
```

3. **Execute Batch Operation:**
```dart
await executeBatchOperation(isar, (isar) async {
  await isar.transactions.putAll(transactionsList);
});
```

### Closing the Database

The database can be closed when the app shuts down:

```dart
await databaseService.close();
```

## Adding New Collections (Models)

When you need to add new Isar collections (models), follow these steps:

### 1. Create the Model Class

Create a new file for your model, for example `lib/data/models/transaction.dart`:

```dart
import 'package:isar_community/isar_community.dart';

part 'transaction.g.dart';

@Collection
class Transaction {
  Id id = Isar.autoIncrement;

  late String name;
  late double amount;
  late String currency;

  // Add other fields as needed
}
```

### 2. Update DatabaseService

Update the `initialize()` method in `database_service.dart` to include the new schema:

```dart
_isar = await Isar.open(
  [
    TransactionSchema,  // Add your schema here
    // Add other schemas as they are created
  ],
  directory: dir.path,
  name: 'deptsandloans',
);
```

### 3. Run Code Generation

After creating or modifying models, run the build_runner to generate the necessary code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For development with automatic code generation:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Import the Generated File

Make sure to import the generated schema in `database_service.dart`:

```dart
import 'package:deptsandloans/data/models/transaction.dart';
```

## Code Generation

### Running Build Runner

To generate Isar schemas and other generated code:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild on file changes)
dart run build_runner watch --delete-conflicting-outputs

# Clean before building
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Generated Files

Build runner creates `.g.dart` files next to your model files. These files:
- Are automatically generated
- Should NOT be manually edited
- Should be committed to version control
- Contain the schema definitions and serialization logic

## Testing

### Unit Tests

Unit tests for the database service are located at:
```
test/core/database/database_service_test.dart
```

Run tests with:

```bash
flutter test test/core/database/database_service_test.dart
```

### Testing Strategy

The current tests verify:
- Singleton pattern implementation
- State management (isInitialized)
- Error handling for uninitialized access
- Close operations

**Note:** Full database operations (initialization, read/write) require platform channel mocking and are better tested in integration tests on actual devices.

### Integration Testing

For testing actual database operations:
1. Run the app on a real device or emulator
2. The home screen displays database status
3. Verify "Database: Ready" appears in green

## Troubleshooting

### Common Issues

#### 1. Build Runner Errors

**Problem:** Code generation fails with conflicts

**Solution:**
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### 2. Missing Plugin Exception in Tests

**Problem:** `MissingPluginException` when running unit tests

**Solution:** This is expected for tests that require platform channels (like path_provider). Use integration tests for full database initialization testing.

#### 3. Database Not Initialized Error

**Problem:** `StateError: DatabaseService has not been initialized`

**Solution:** Ensure `initialize()` is called before accessing the database:
```dart
final databaseService = DatabaseService();
await databaseService.initialize();
final isar = databaseService.instance; // Now safe
```

#### 4. Dependency Version Conflicts

**Problem:** Version conflicts between build_runner and isar_community_generator

**Solution:** The project uses compatible versions:
- build_runner: ^2.7.1
- isar_community_generator: ^3.3.0

If you encounter issues, run:
```bash
flutter pub get
```

## Database Location

The database file is stored at:
- **Android:** `/data/data/com.example.deptsandloans/app_flutter/deptsandloans.isar`
- **iOS:** `<Application Documents Directory>/deptsandloans.isar`
- **Desktop:** Platform-specific documents directory

You can view the path in the logs when the app initializes.

## Performance Considerations

1. **Indexes:** Isar automatically creates indexes for efficient queries
2. **Lazy Loading:** Use lazy loading for large collections
3. **Batch Operations:** Use batch operations for multiple inserts/updates
4. **Transactions:** Use transactions for atomic operations
5. **Watch Streams:** Isar supports reactive queries with streams

## Security Considerations

- Data is stored unencrypted by default
- Local database is accessible only to the app
- No network transmission of data (local-first architecture)
- For future: Consider encryption for sensitive financial data

## Migration Strategy

### Schema Changes

Isar handles most migrations automatically:
1. Adding new fields: Isar adds them with default values
2. Removing fields: Isar ignores unknown fields
3. Renaming fields: Requires manual migration

### Version Management

When schema changes are needed:
1. Update the model class
2. Run code generation
3. Isar will handle the migration on next app start

For breaking changes:
1. Implement migration logic in `DatabaseService.initialize()`
2. Use `DatabaseMigrationHelper` utilities
3. Test thoroughly before deployment

## Logging

All database operations are logged using `dart:developer`:

- **Initialization:** Logged at INFO level
- **Operations:** Logged with operation names
- **Errors:** Logged at SEVERE level with stack traces

View logs in:
- Flutter DevTools
- Android Logcat
- iOS Console

## Next Steps

After completing the database setup:

1. **TASK-0008:** Create Transaction Model with Isar annotations
2. **TASK-0009:** Create Repayment Model
3. **TASK-0010:** Create Reminder Model
4. **TASK-0011:** Implement Transaction Repository
5. Run code generation to create schemas
6. Test database operations with real data

## Migration to isar_community

### Background

The project has been migrated from the original `isar` package to `isar_community`, which is a community-maintained fork that provides:
- Active development and maintenance
- Bug fixes and updates for version 3.x
- Better compatibility with current Flutter SDK versions
- Enhanced stability and reliability

### Migration Steps

The migration involved the following changes:

1. **Package Updates:**
   - `isar` → `isar_community`
   - `isar_flutter_libs` → `isar_community_flutter_libs`
   - `isar_generator` → `isar_community_generator`

2. **Import Changes:**
   All import statements were updated from:
   ```dart
   import 'package:isar/isar.dart';
   ```
   to:
   ```dart
   import 'package:isar_community/isar_community.dart';
   ```

3. **Version Updates:**
   - isar_community: 3.3.0 (from isar 3.1.0+1)
   - build_runner: ^2.7.1 (from 2.4.13) - Required for compatibility

4. **API Compatibility:**
   The `isar_community` package maintains API compatibility with the original `isar` package. No code changes are required beyond import statements.

### Files Modified

- `lib/core/database/database_helpers.dart`
- `lib/core/database/database_service.dart`
- `lib/data/models/placeholder.dart`
- `test/golden/screens/home_screen_test.dart`
- `pubspec.yaml`

### Benefits

- **Active Maintenance:** Regular updates and bug fixes
- **Community Support:** Active community development
- **Future-Proof:** Continued development ensures compatibility with future Flutter versions
- **Stability:** Focus on bug fixes and stability improvements for v3.x

## References

- [Isar Community Documentation](https://isar-community.dev/)
- [Isar Community GitHub Repository](https://github.com/isar-community/isar)
- [Isar Community Package on pub.dev](https://pub.dev/packages/isar_community)
- [Isar Community Quickstart Guide](https://isar-community.dev/v3/tutorials/quickstart.html)
- [Flutter Local Storage](https://docs.flutter.dev/cookbook/persistence)
- [path_provider Package](https://pub.dev/packages/path_provider)

## Support

For issues related to:
- **Isar Community:** Check [Isar Community GitHub Issues](https://github.com/isar-community/isar/issues)
- **Flutter:** Check [Flutter Documentation](https://docs.flutter.dev/)
- **This Project:** See project backlog and documentation

---

**Document Version:** 1.1
**Last Updated:** 2025-11-24
**Status:** ✅ Completed (Migrated to isar_community)
