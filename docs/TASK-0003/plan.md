# TASK-0003: Setup Local Database - Implementation Plan

## Task Description
Integrate local database solution (e.g., sqflite, hive, or isar) for Local First data storage

## Background Context
This is a Flutter application for tracking debts and loans. The app requires a robust local-first storage solution to persist transaction data, repayments, and reminders offline without requiring user registration or cloud sync.

## Technology Selection

### Recommended Solution: **Isar**

**Rationale:**
- **Performance**: Isar is built in C++ and offers excellent performance for mobile devices
- **Type Safety**: Full Dart type safety with compile-time checks
- **Zero Configuration**: No need for SQL queries or migrations in early stages
- **Developer Experience**: Clean API with code generation
- **Query Capabilities**: Powerful filtering, sorting, and indexing
- **Cross-platform**: Works on Android, iOS, desktop, and web
- **Active Development**: Well-maintained with good community support
- **Local-first Architecture**: Perfect fit for offline-first applications

**Alternatives Considered:**
- **sqflite**: More setup overhead, requires SQL knowledge, but widely used
- **hive**: Simpler but less performant for complex queries
- **drift** (formerly moor): Type-safe SQL, but more complex setup

## Implementation Steps

### 1. Add Dependencies
```yaml
# pubspec.yaml additions
dependencies:
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.1

dev_dependencies:
  isar_generator: ^3.1.0+1
  build_runner: ^2.4.6
```

**Commands:**
```bash
flutter pub add isar isar_flutter_libs path_provider
flutter pub add dev:isar_generator build_runner
```

### 2. Create Database Service Layer

**File:** `lib/core/database/database_service.dart`

**Responsibilities:**
- Initialize Isar database
- Provide database instance to repositories
- Handle database lifecycle (open/close)
- Manage database schema versioning

**Key Methods:**
- `Future<Isar> initialize()` - Opens Isar instance with all schemas
- `Future<void> close()` - Closes database connection
- `Isar get instance` - Returns singleton database instance

### 3. Define Database Schemas

Create Isar collection models (will be implemented in TASK-0008, TASK-0009, TASK-0010):
- Transaction schema
- Repayment schema
- Reminder schema

### 4. Setup Database Initialization in App

**File:** `lib/main.dart`

**Steps:**
- Initialize database service before running the app
- Pass database instance to repository layer
- Ensure proper error handling during initialization

**Example:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseService = DatabaseService();
  await databaseService.initialize();

  runApp(MyApp(databaseService: databaseService));
}
```

### 5. Implement Database Helper Utilities

**File:** `lib/core/database/database_helpers.dart`

**Utilities:**
- Error handling wrappers
- Transaction helpers for batch operations
- Migration utilities (for future use)

### 6. Setup Code Generation Configuration

**File:** `build.yaml` (if needed for custom configuration)

Configure build_runner for Isar code generation:
- Specify output directories
- Configure generation options

### 7. Testing Setup

**File:** `test/core/database/database_service_test.dart`

**Test Cases:**
- Database initialization succeeds
- Database can be opened and closed
- Singleton pattern works correctly
- Error handling for initialization failures
- In-memory database for testing (using `Isar.openInMemory()`)

### 8. Documentation

**File:** `docs/TASK-0003/database_setup.md`

**Documentation Content:**
- How to run code generation
- Database architecture overview
- How to add new collections
- Testing guidelines
- Troubleshooting common issues

## Acceptance Criteria

- [ ] Isar dependencies added to `pubspec.yaml`
- [ ] `DatabaseService` class created with initialization logic
- [ ] Database service integrated into app startup in `main.dart`
- [ ] Code generation setup and documented
- [ ] Unit tests for database service pass
- [ ] App can start successfully with database initialized
- [ ] No runtime errors related to database initialization
- [ ] Documentation created for database setup

## Code Generation Workflow

After implementing the database service:

```bash
# Generate Isar schemas (will be used in later tasks)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

## Dependencies on Other Tasks

**Blocking:**
- None - this is a foundational task

**Blocked By This Task:**
- TASK-0008: Create Transaction Model
- TASK-0009: Create Repayment Model
- TASK-0010: Create Reminder Model
- TASK-0011: Implement Transaction Repository
- TASK-0012: Implement Repayment Repository
- TASK-0013: Implement Reminder Repository

## Potential Challenges & Solutions

### Challenge 1: Platform-specific initialization
**Solution:** Use `isar_flutter_libs` which handles platform differences automatically

### Challenge 2: Database path on different platforms
**Solution:** Use `path_provider` package to get the correct directory path for each platform

### Challenge 3: Code generation errors
**Solution:** Ensure all dependencies are added before running build_runner; check for naming conflicts

### Challenge 4: Testing with real database files
**Solution:** Use `Isar.openInMemory()` for unit tests to avoid file system dependencies

## Migration Strategy (Future)

When schema changes are needed:
1. Isar handles most migrations automatically
2. For breaking changes, implement migration logic in `DatabaseService`
3. Consider versioning strategy for production releases

## Performance Considerations

- Isar automatically creates indexes for queries
- Use lazy loading for large collections
- Batch operations for bulk inserts/updates
- Close database connections when app is terminated

## Security Considerations

- Data stored locally is unencrypted by default
- For future: Consider encryption if sensitive financial data requires it
- No user authentication required (per MVP requirements)

## Next Steps After Completion

1. Proceed to TASK-0008: Create Transaction Model
2. Implement Isar collection annotations
3. Generate Isar schemas using build_runner
4. Test database operations with actual data models

## References

- [Isar Documentation](https://isar.dev/)
- [Isar GitHub Repository](https://github.com/isar/isar)
- [Flutter Local Storage Options](https://docs.flutter.dev/cookbook/persistence)
- [path_provider Package](https://pub.dev/packages/path_provider)

## Estimated Complexity

**Complexity Level:** Medium

**Time Estimate:** 2-3 hours (including testing and documentation)

**Lines of Code:** ~150-200 lines
