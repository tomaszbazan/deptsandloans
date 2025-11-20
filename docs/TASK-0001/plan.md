# TASK-0001: Initialize Flutter Project - Implementation Plan

## Objective
Create a new Flutter project with Android target platform and configure basic project structure.

## Prerequisites
- Flutter SDK installed and configured
- Android development environment set up (Android SDK, Android Studio)
- Dart SDK (comes with Flutter)

## Implementation Steps

### 1. Verify Flutter Installation
- Check Flutter version and installation status
- Verify Android toolchain is properly configured
- Check that all required components are available

**Command:**
```bash
flutter doctor -v
```

### 2. Create Flutter Project
- Initialize a new Flutter project with the name `deptsandloans`
- Use default Flutter template
- Ensure Android platform is enabled by default

**Command:**
```bash
flutter create deptsandloans --platforms=android
```

**Note:** Since we're already in the project directory, we need to either:
- Create the project in a temporary location and copy relevant files, OR
- Manually set up the necessary Flutter structure if not already present

### 3. Verify Project Structure
Ensure the following directory structure exists:
```
deptsandloans/
├── android/              # Android-specific files
├── lib/                  # Dart source code
│   └── main.dart        # Main entry point
├── test/                # Test files
├── pubspec.yaml         # Project dependencies
├── analysis_options.yaml # Linting rules
└── README.md            # Project documentation
```

### 4. Configure pubspec.yaml
- Set application name: `deptsandloans`
- Set description: "A local-first app for tracking debts and loans"
- Configure minimum Android SDK version (recommended: SDK 21+)
- Set up basic project metadata (version, author, etc.)

### 5. Update android/app/build.gradle
Configure Android-specific settings:
- Set `minSdkVersion` to 21 or higher (for modern Android features)
- Set `targetSdkVersion` to latest stable version
- Set `compileSdkVersion` to latest stable version
- Configure application ID: `pl.btsoftware.deptsandloans`

### 6. Configure Main Entry Point
- Review and clean up `lib/main.dart`
- Set up basic MaterialApp structure
- Remove default counter example code
- Prepare for future navigation and theming setup

### 7. Create Basic Folder Structure
Set up the recommended architecture folders in `lib/`:
```
lib/
├── main.dart
├── core/                # Shared utilities, constants, extensions
├── data/                # Models, repositories, data sources
├── domain/              # Business logic, use cases
└── presentation/        # UI widgets, screens, state management
```

### 8. Initial Git Setup (if applicable)
- Ensure `.gitignore` is properly configured for Flutter
- Make initial commit with project structure

### 9. Verify Project Runs
- Run the app on an Android emulator or physical device
- Verify hot reload functionality works
- Confirm no build errors

**Command:**
```bash
flutter run
```

### 10. Clean Up
- Remove unnecessary default code and comments
- Ensure code follows project conventions from CLAUDE.md
- Remove default Flutter demo widgets

## Verification Checklist
- [ ] `flutter doctor` shows no critical issues for Android development
- [ ] Project structure matches Flutter conventions
- [ ] `pubspec.yaml` is properly configured
- [ ] Android configuration is set with appropriate SDK versions
- [ ] App builds successfully without errors
- [ ] App runs on Android emulator/device
- [ ] Hot reload works correctly
- [ ] Basic folder structure for future development is in place
- [ ] Git repository is initialized (if applicable)

## Expected Outcome
A clean, working Flutter project targeting Android platform with:
- Proper project structure following Flutter best practices
- Android platform configured and working
- Basic folder organization for scalable development
- Ready for next phase: development environment configuration (TASK-0002)

## Estimated Effort
- Time: 30-60 minutes
- Complexity: Low (mostly setup and configuration)

## Dependencies
None (this is the first task)

## Blocks
None

## Notes
- If the project directory already exists, we may need to selectively initialize Flutter components
- Ensure Android emulator is set up or physical device is available for testing
- Follow naming conventions from CLAUDE.md (snake_case for files, PascalCase for classes)
