import 'package:deptsandloans/data/models/reminder_type.dart';
import 'package:deptsandloans/presentation/widgets/reminder_configuration_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';

void main() {
  Widget createTestWidget({
    required bool isEnabled,
    ReminderType? reminderType,
    DateTime? oneTimeReminderDate,
    int? recurringIntervalDays,
    String? reminderTypeError,
    String? reminderDateError,
    String? intervalError,
    required ValueChanged<bool> onEnabledChanged,
    required ValueChanged<ReminderType?> onReminderTypeChanged,
    required ValueChanged<DateTime?> onOneTimeReminderDateChanged,
    required ValueChanged<int?> onRecurringIntervalDaysChanged,
  }) {
    return AppFixture.createDefaultApp(
      Scaffold(
        body: ReminderConfigurationWidget(
          isEnabled: isEnabled,
          reminderType: reminderType,
          oneTimeReminderDate: oneTimeReminderDate,
          recurringIntervalDays: recurringIntervalDays,
          reminderTypeError: reminderTypeError,
          reminderDateError: reminderDateError,
          intervalError: intervalError,
          onEnabledChanged: onEnabledChanged,
          onReminderTypeChanged: onReminderTypeChanged,
          onOneTimeReminderDateChanged: onOneTimeReminderDateChanged,
          onRecurringIntervalDaysChanged: onRecurringIntervalDaysChanged,
        ),
      ),
    );
  }

  group('ReminderConfigurationWidget', () {
    testWidgets('renders with reminder disabled', (tester) async {
      await tester.pumpWidget(
        createTestWidget(isEnabled: false, onEnabledChanged: (_) {}, onReminderTypeChanged: (_) {}, onOneTimeReminderDateChanged: (_) {}, onRecurringIntervalDaysChanged: (_) {}),
      );

      expect(find.text('Reminder'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);

      expect(find.text('Reminder Type'), findsNothing);
    });

    testWidgets('shows reminder type options when enabled', (tester) async {
      await tester.pumpWidget(
        createTestWidget(isEnabled: true, onEnabledChanged: (_) {}, onReminderTypeChanged: (_) {}, onOneTimeReminderDateChanged: (_) {}, onRecurringIntervalDaysChanged: (_) {}),
      );

      expect(find.text('Reminder Type'), findsOneWidget);
      expect(find.text('One-time'), findsOneWidget);
      expect(find.text('Recurring'), findsOneWidget);
    });

    testWidgets('calls onEnabledChanged when switch is toggled', (tester) async {
      bool? capturedValue;

      await tester.pumpWidget(
        createTestWidget(
          isEnabled: false,
          onEnabledChanged: (value) => capturedValue = value,
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      await tester.tap(find.byType(Switch));
      expect(capturedValue, true);
    });

    testWidgets('shows date picker for one-time reminder', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.oneTime,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      expect(find.text('Reminder Date'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
      expect(find.text('Interval (days)'), findsNothing);
    });

    testWidgets('shows interval input for recurring reminder', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.recurring,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      expect(find.text('Interval (days)'), findsOneWidget);
      expect(find.text('Reminder Date'), findsNothing);
    });

    testWidgets('displays validation errors', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.oneTime,
          reminderTypeError: null,
          reminderDateError: 'Date is required',
          intervalError: null,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      expect(find.text('Date is required'), findsOneWidget);
    });

    testWidgets('calls onReminderTypeChanged when type is selected', (tester) async {
      ReminderType? capturedType;

      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (type) => capturedType = type,
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      await tester.tap(find.text('One-time'));
      expect(capturedType, ReminderType.oneTime);
    });

    testWidgets('calls onRecurringIntervalDaysChanged when interval is entered', (tester) async {
      int? capturedInterval;

      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.recurring,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (interval) => capturedInterval = interval,
        ),
      );

      await tester.enterText(find.byType(TextField), '7');
      expect(capturedInterval, 7);
    });

    testWidgets('displays selected date for one-time reminder', (tester) async {
      final selectedDate = DateTime(2025, 12, 25);

      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.oneTime,
          oneTimeReminderDate: selectedDate,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      expect(find.textContaining('Dec'), findsOneWidget);
    });

    testWidgets('displays interval value for recurring reminder', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          isEnabled: true,
          reminderType: ReminderType.recurring,
          recurringIntervalDays: 14,
          onEnabledChanged: (_) {},
          onReminderTypeChanged: (_) {},
          onOneTimeReminderDateChanged: (_) {},
          onRecurringIntervalDaysChanged: (_) {},
        ),
      );

      expect(find.text('14'), findsOneWidget);
    });
  });
}
