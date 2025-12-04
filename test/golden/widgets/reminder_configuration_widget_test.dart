import 'package:alchemist/alchemist.dart';
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
        GoldenTestScenario(name: 'disabled', child: _buildTestWidget(isEnabled: false)),
        GoldenTestScenario(name: 'enabled no type selected', child: _buildTestWidget(isEnabled: true)),
        GoldenTestScenario(
          name: 'one-time reminder without date',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime),
        ),
        GoldenTestScenario(
          name: 'one-time reminder with date',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, oneTimeReminderDate: DateTime(2025, 12, 25)),
        ),
        GoldenTestScenario(
          name: 'recurring reminder without interval',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring),
        ),
        GoldenTestScenario(
          name: 'recurring reminder with interval',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, recurringIntervalDays: 7),
        ),
        GoldenTestScenario(
          name: 'one-time with error',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.oneTime, reminderDateError: 'Reminder date is required'),
        ),
        GoldenTestScenario(
          name: 'recurring with error',
          child: _buildTestWidget(isEnabled: true, reminderType: ReminderType.recurring, intervalError: 'Interval must be between 1 and 365 days'),
        ),
        GoldenTestScenario(
          name: 'enabled with type error',
          child: _buildTestWidget(isEnabled: true, reminderTypeError: 'Please select a reminder type'),
        ),
      ],
    ),
  );
}

Widget _buildTestWidget({
  required bool isEnabled,
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
  );
}
