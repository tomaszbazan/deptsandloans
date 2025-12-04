import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../data/models/reminder_type.dart';
import '../../l10n/app_localizations.dart';

class ReminderConfigurationWidget extends StatelessWidget {
  final bool isEnabled;
  final ReminderType? reminderType;
  final DateTime? oneTimeReminderDate;
  final int? recurringIntervalDays;
  final String? reminderTypeError;
  final String? reminderDateError;
  final String? intervalError;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<ReminderType?> onReminderTypeChanged;
  final ValueChanged<DateTime?> onOneTimeReminderDateChanged;
  final ValueChanged<int?> onRecurringIntervalDaysChanged;

  const ReminderConfigurationWidget({
    required this.isEnabled,
    required this.reminderType,
    required this.oneTimeReminderDate,
    required this.recurringIntervalDays,
    required this.reminderTypeError,
    required this.reminderDateError,
    required this.intervalError,
    required this.onEnabledChanged,
    required this.onReminderTypeChanged,
    required this.onOneTimeReminderDateChanged,
    required this.onRecurringIntervalDaysChanged,
    super.key,
  });

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = oneTimeReminderDate ?? now.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? initialDate : now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      onOneTimeReminderDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.reminder, style: theme.textTheme.titleMedium)),
                Switch(value: isEnabled, onChanged: onEnabledChanged),
              ],
            ),
            if (isEnabled) ...[
              const SizedBox(height: 16),
              Text(l10n.reminderType, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onReminderTypeChanged(ReminderType.oneTime),
                      child: Row(
                        children: [
                          Radio<ReminderType>(value: ReminderType.oneTime, groupValue: reminderType, onChanged: onReminderTypeChanged),
                          Expanded(child: Text(l10n.oneTime)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => onReminderTypeChanged(ReminderType.recurring),
                      child: Row(
                        children: [
                          Radio<ReminderType>(value: ReminderType.recurring, groupValue: reminderType, onChanged: onReminderTypeChanged),
                          Expanded(child: Text(l10n.recurring)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (reminderTypeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(reminderTypeError!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                ),
              if (reminderType == ReminderType.oneTime) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.reminderDate,
                      border: const OutlineInputBorder(),
                      errorText: reminderDateError,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (oneTimeReminderDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => onOneTimeReminderDateChanged(null),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                    child: Text(
                      oneTimeReminderDate != null ? _formatDate(oneTimeReminderDate!) : l10n.notSet,
                      style: TextStyle(color: oneTimeReminderDate != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
              if (reminderType == ReminderType.recurring) ...[
                const SizedBox(height: 16),
                TextFormField(
                  key: ValueKey('interval_$recurringIntervalDays'),
                  initialValue: recurringIntervalDays?.toString() ?? '',
                  decoration: InputDecoration(labelText: l10n.intervalDays, border: const OutlineInputBorder(), errorText: intervalError, suffix: Text(l10n.days)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final interval = int.tryParse(value);
                    onRecurringIntervalDaysChanged(interval);
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
