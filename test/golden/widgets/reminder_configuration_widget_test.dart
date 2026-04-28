import 'package:alchemist/alchemist.dart';
import 'package:deptsandloans/core/theme/app_theme.dart';
import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/presentation/widgets/reminder_configuration_widget.dart';
import 'package:flutter/material.dart';

import '../../fixtures/app_fixture.dart';

void main() {
  goldenTest(
    'ReminderConfigurationWidget renders correctly in different states',
    fileName: 'reminder_configuration_widget',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'disabled',
          child: _buildTestWidget(isEnabled: false, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'enabled no type selected',
          child: _buildTestWidget(isEnabled: true, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'one-time reminder without date',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'one-time reminder with date',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, oneTimeReminderDate: DateTime(2025, 12, 25), theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring reminder without interval',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring reminder with interval',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, recurringIntervalDays: 7, theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'one-time with error',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, reminderDateError: 'Reminder date is required', theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring with error',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, intervalError: 'Interval must be between 1 and 365 days', theme: AppTheme.lightTheme()),
        ),
        GoldenTestScenario(
          name: 'enabled with type error',
          child: _buildTestWidget(isEnabled: true, reminderTypeError: 'Please select a reminder type', theme: AppTheme.lightTheme()),
        ),
      ],
    ),
  );

  goldenTest(
    'ReminderConfigurationWidget renders correctly in different states in dark mode',
    fileName: 'reminder_configuration_widget_dark',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'disabled_dark',
          child: _buildTestWidget(isEnabled: false, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'enabled_no_type_selected_dark',
          child: _buildTestWidget(isEnabled: true, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'one_time_reminder_without_date_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'one_time_reminder_with_date_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, oneTimeReminderDate: DateTime(2025, 12, 25), theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring_reminder_without_interval_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring_reminder_with_interval_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, recurringIntervalDays: 7, theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'one_time_with_error_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, reminderDateError: 'Reminder date is required', theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'recurring_with_error_dark',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, intervalError: 'Interval must be between 1 and 365 days', theme: AppTheme.darkTheme()),
        ),
        GoldenTestScenario(
          name: 'enabled_with_type_error_dark',
          child: _buildTestWidget(isEnabled: true, reminderTypeError: 'Please select a reminder type', theme: AppTheme.darkTheme()),
        ),
      ],
    ),
  );
}

Widget _buildTestWidget({
  required bool isEnabled,
  required ThemeData theme,
  ReminderType? reminderType,
  DateTime? oneTimeReminderDate,
  int? recurringIntervalDays,
  String? reminderTypeError,
  String? reminderDateError,
  String? intervalError,
}) {
  return AppFixture.createDefaultApp(
    SizedBox(
      width: 400,
      child: ReminderConfigurationWidget(
        isEnabled: isEnabled,
        reminderType: reminderType,
        oneTimeReminderDate: oneTimeReminderDate,
        recurringIntervalDays: recurringIntervalDays,
        reminderTypeError: reminderTypeError,
        reminderDateError: reminderDateError,
        intervalError: intervalError,
        onEnabledChanged: (_) {},
        onReminderTypeChanged: (_) {},
        onOneTimeReminderDateChanged: (_) {},
        onRecurringIntervalDaysChanged: (_) {},
      ),
    ),
    theme: theme,
  );
}
