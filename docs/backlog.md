# Product Backlog - Depts and Loans Register (MVP)

## Project Setup

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0001 | Initialize Flutter Project | Create new Flutter project with Android target platform and configure basic project structure | [  ] |
| TASK-0002 | Configure Development Environment | Set up linting rules (flutter_lints), analysis_options.yaml, and development dependencies | [ ]  |
| TASK-0003 | Setup Local Database | Integrate local database solution (e.g., sqflite, hive, or isar) for Local First data storage | [ ]  |
| TASK-0004 | Configure Localization | Set up i18n support for Polish (PL) and English (EN) with automatic locale detection | [ ]  |
| TASK-0005 | Setup Navigation | Implement routing solution (go_router) for navigation between screens | [ ]  |
| TASK-0006 | Configure Theme System | Create ThemeData for light and dark modes with color schemes and component themes | [ ]  |

## Data Layer & Models

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0007 | Create Transaction Model | Define Transaction entity with fields: id, type (debt/loan), name, amount, currency, description, dueDate, status | [ ] |
| TASK-0008 | Create Repayment Model | Define Repayment entity with fields: id, transactionId, amount, date, timestamp | [ ] |
| TASK-0009 | Create Reminder Model | Define Reminder entity with fields: id, transactionId, type (one-time/recurring), intervalDays, nextReminderDate | [ ] |
| TASK-0010 | Implement Transaction Repository | Create repository layer for CRUD operations on transactions with local database | [ ] |
| TASK-0011 | Implement Repayment Repository | Create repository layer for recording and retrieving repayments | [ ] |
| TASK-0012 | Implement Reminder Repository | Create repository layer for managing reminders | [ ] |

## Transaction Management

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0013 | Create Transaction Form Screen | Build form UI for adding/editing transactions with Name, Amount, Currency, Description, and Due Date fields | [ ] |
| TASK-0014 | Implement Form Validation | Add validation for required Name field (non-empty) and Description field (max 200 characters) | [ ] |
| TASK-0015 | Implement Currency Selection | Create currency picker supporting PLN, EUR, USD, GBP with proper locale-based formatting | [ ] |
| TASK-0016 | Implement Save Transaction | Connect form to repository to save new transactions to local database | [ ] |
| TASK-0017 | Implement Edit Transaction | Enable editing existing transactions (excluding initial Amount) | [ ] |
| TASK-0018 | Implement Delete Transaction | Add functionality to delete transactions with confirmation dialog | [ ] |

## Transaction Listing & Display

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0019 | Create Main Screen Layout | Build main screen with two tabs: "My Debts" and "My Loans" | [ ] |
| TASK-0020 | Implement Transaction List Widget | Create reusable list widget to display transactions with name, amount, balance, and due date | [ ] |
| TASK-0021 | Implement Transaction Sorting | Sort active transactions by due date (ascending), placing transactions without due date at the bottom | [ ] |
| TASK-0022 | Implement Overdue Highlighting | Visually highlight (red color) transactions where due date has passed and remaining balance > 0 | [ ] |
| TASK-0023 | Implement FAB for Adding | Add Floating Action Button to open transaction form for adding new debt/loan | [ ] |
| TASK-0024 | Create Transaction Details Screen | Build screen showing full transaction details including repayment history and progress | [ ] |

## Repayments & Transaction Status

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0025 | Create Repayment Form | Build UI for recording partial repayments with amount input | [ ] |
| TASK-0026 | Implement Repayment Validation | Prevent entering repayment amount exceeding remaining balance | [ ] |
| TASK-0027 | Calculate Remaining Balance | Implement logic to calculate current balance based on initial amount and repayments | [ ] |
| TASK-0028 | Implement Progress Bar | Create visual progress bar showing repayment percentage on transaction details screen | [ ] |
| TASK-0029 | Implement Auto-Completion | Automatically mark transaction as completed when balance reaches zero | [ ] |
| TASK-0030 | Implement Manual Completion | Add option for user to manually mark transaction as completed at any time | [ ] |

## Archive Management

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0031 | Implement Archive Section | Create collapsible accordion section for completed transactions below active list | [ ] |
| TASK-0032 | Default Collapsed State | Ensure Archive section is collapsed by default on app launch | [ ] |
| TASK-0033 | Implement Archive Toggle | Add functionality to expand/collapse Archive section by clicking header | [ ] |
| TASK-0034 | Display Completed Transactions | Show completed transactions in Archive with read-only view | [ ] |

## Reminders & Notifications

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0035 | Setup Push Notifications | Configure Android push notifications permissions and local notification channel | [ ] |
| TASK-0036 | Implement Reminder Configuration UI | Add UI controls in transaction form for setting one-time or recurring reminders | [ ] |
| TASK-0037 | Implement One-Time Reminder | Schedule single push notification at 19:00 on specified date | [ ] |
| TASK-0038 | Implement Recurring Reminder | Schedule repeating notifications every X days at 19:00 | [ ] |
| TASK-0039 | Implement Reminder Cancellation | Automatically cancel all notifications when transaction reaches 100% repaid status | [ ] |
| TASK-0040 | Create Notification Content | Format notification with transaction name, amount, and remaining balance | [ ] |

## Localization & Currency Formatting

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0041 | Create Translation Files | Create ARB files for Polish and English translations of all UI strings | [ ] |
| TASK-0042 | Implement Locale Detection | Automatically set app language based on device locale (default to English) | [ ] |
| TASK-0043 | Implement Currency Formatting | Format amounts according to device locale (separators, decimal places, currency symbols) | [ ] |
| TASK-0044 | Test Multi-Currency Display | Verify correct display of PLN, EUR, USD, GBP in both locales | [ ] |

## UI/UX Polish

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0045 | Implement Dark Mode Support | Apply dark theme based on device system settings using ThemeMode.system | [ ] |
| TASK-0046 | Add App Icon | Design and add application icon for Android | [ ] |
| TASK-0047 | Add Empty States | Create empty state UI for lists with no transactions | [ ] |
| TASK-0048 | Add Loading States | Implement loading indicators for async operations | [ ] |
| TASK-0049 | Refine Visual Design | Apply shadows, spacing, typography hierarchy, and color palette per PRD guidelines | [ ] |
| TASK-0050 | Truncate Description Display | Show max 30 characters of description on list items with "..." truncation | [ ] |

## Testing & Quality Assurance

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0051 | Write Unit Tests for Models | Test data models, serialization, and business logic | [ ] |
| TASK-0052 | Write Unit Tests for Repositories | Test CRUD operations and data persistence | [ ] |
| TASK-0053 | Write Widget Tests | Test UI components and user interactions | [ ] |
| TASK-0054 | Write Integration Tests | Test end-to-end user flows: add transaction, record repayment, complete transaction | [ ] |
| TASK-0055 | Test Localization | Verify correct translations and currency formatting in both locales | [ ] |
| TASK-0056 | Test Dark Mode | Verify UI appearance and readability in dark theme | [ ] |
| TASK-0057 | Test Notification Delivery | Verify push notifications are delivered at 19:00 with correct content | [ ] |

## First Launch Experience

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0058 | Implement First Launch Detection | Detect app first launch and show appropriate empty state | [ ] |
| TASK-0059 | Test Data Persistence | Verify local data persists after app restart | [ ] |
| TASK-0060 | Test No-Registration Flow | Ensure app works immediately without login/registration | [ ] |

## Build & Release

| ID | Task Name | Description | Done |
|:---|:----------|:------------|:----:|
| TASK-0061 | Configure Build Settings | Set up Android build configuration, version code, and signing | [ ] |
| TASK-0062 | Generate Release Build | Create release APK/AAB for Android | [ ] |
| TASK-0063 | Prepare Store Assets | Create screenshots, description, and promotional materials | [ ] |
| TASK-0064 | Submit to Play Store | Upload and submit MVP to Google Play Store for review | [ ] |
