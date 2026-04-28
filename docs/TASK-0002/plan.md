# TASK-0002: Configure Development Environment

## Task Description
Set up linting rules (flutter_lints), analysis_options.yaml, and development dependencies.

## Goal
Establish a robust development environment with proper code quality checks, linting rules, and necessary development dependencies to ensure code consistency and catch common issues early in the development process.

## Prerequisites
- Flutter project already initialized (TASK-0001 completed)
- Flutter SDK installed and configured

## Implementation Steps

### 1. Add flutter_lints Package
**Objective:** Add the official Flutter linting package as a dev dependency.

**Actions:**
- Run `flutter pub add dev:flutter_lints` to add the package to `pubspec.yaml`
- Verify the package is added under `dev_dependencies`

**Expected Outcome:**
- `flutter_lints` appears in `pubspec.yaml` under `dev_dependencies` section

### 2. Create analysis_options.yaml
**Objective:** Configure the Dart analyzer with Flutter-recommended lint rules.

**Actions:**
- Create `analysis_options.yaml` in the project root
- Include the flutter_lints package rules
- Configure additional custom rules based on project needs

**File Structure:**
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Core rules (already included via flutter_lints)
    # Additional project-specific rules can be added here

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

**Expected Outcome:**
- `analysis_options.yaml` file created with proper configuration
- Analyzer recognizes the configuration

### 3. Add Additional Development Dependencies
**Objective:** Set up essential development tools for the project.

**Actions:**
Add the following dev dependencies:
- `build_runner` - for code generation (needed for json_serializable and other generators)
- `json_serializable` - for JSON serialization code generation
- `json_annotation` - annotations for JSON serialization

**Commands:**
```bash
flutter pub add dev:build_runner
flutter pub add json_annotation
flutter pub add dev:json_serializable
```

**Expected Outcome:**
- All development dependencies properly added to `pubspec.yaml`
- Dependencies downloaded and available for use

### 4. Verify Configuration
**Objective:** Ensure the development environment is properly configured.

**Actions:**
- Run `flutter analyze` to verify analyzer configuration
- Check for any existing issues in the codebase
- Verify that lint rules are being applied

**Expected Outcome:**
- No configuration errors
- Analyzer runs successfully
- Lint rules are active and checking code

### 5. Test Code Generation Setup
**Objective:** Verify that build_runner is properly configured.

**Actions:**
- Run `dart run build_runner build --delete-conflicting-outputs`
- Verify the command executes without errors (even if no files to generate yet)

**Expected Outcome:**
- build_runner executes successfully
- No configuration errors

## Success Criteria
- [ ] `flutter_lints` package added as dev dependency
- [ ] `analysis_options.yaml` file created with proper configuration
- [ ] Additional dev dependencies (build_runner, json_serializable) added
- [ ] `flutter analyze` runs without configuration errors
- [ ] Linting rules are active and working
- [ ] build_runner command executes successfully

## Testing Steps
1. Run `flutter pub get` to ensure all dependencies are fetched
2. Run `flutter analyze` to check for any issues
3. Run `dart run build_runner build --delete-conflicting-outputs` to verify code generation setup
4. Open a Dart file and intentionally introduce a lint violation (e.g., unused import) to verify linting is active
5. Verify IDE/editor shows lint warnings and suggestions

## Potential Issues & Solutions

**Issue:** `flutter_lints` conflicts with existing lint package
- **Solution:** Remove any existing lint packages (e.g., `pedantic`, `effective_dart`) and use only `flutter_lints`

**Issue:** Analyzer performance issues
- **Solution:** Add frequently generated files to `exclude` section in `analysis_options.yaml`

**Issue:** Build runner fails
- **Solution:** Ensure Flutter SDK is up to date and run `flutter clean` before retrying

## Notes
- The `flutter_lints` package includes both `flutter.yaml` and `flutter_repo.yaml` rule sets
- We're using the standard `flutter.yaml` which is suitable for Flutter applications
- Custom rules can be added incrementally as the project grows
- Generated files (*.g.dart, *.freezed.dart) should be excluded from analysis to improve performance

## Time Estimate
- Setup: 15-20 minutes
- Testing and verification: 10 minutes
- Total: ~30 minutes

## Dependencies
- Requires: TASK-0001 (Initialize Flutter Project) ✓
- Required by: All subsequent development tasks

## References
- [Flutter Lints Package](https://pub.dev/packages/flutter_lints)
- [Effective Dart](https://dart.dev/effective-dart)
- [Customizing Static Analysis](https://dart.dev/tools/analysis)
- [Build Runner Documentation](https://pub.dev/packages/build_runner)
