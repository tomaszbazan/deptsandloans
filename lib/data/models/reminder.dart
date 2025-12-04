import 'package:isar_community/isar.dart';
import 'reminder_type.dart';

part 'reminder.g.dart';

@Collection()
class Reminder {
  Id id = Isar.autoIncrement;

  @Index()
  late int transactionId;

  @Enumerated(EnumType.name)
  late ReminderType type;

  int? intervalDays;

  late DateTime nextReminderDate;

  int? notificationId;

  late DateTime createdAt;

  Reminder();

  bool get isOneTime => type == ReminderType.oneTime;

  bool get isRecurring => type == ReminderType.recurring;

  void validate() {
    final errors = <String>[];

    if (type == ReminderType.recurring) {
      if (intervalDays == null || intervalDays! <= 0) {
        errors.add('Recurring reminders must have intervalDays > 0');
      }
    } else if (type == ReminderType.oneTime) {
      if (intervalDays != null) {
        errors.add('One-time reminders must have null intervalDays');
      }
    }

    if (errors.isNotEmpty) {
      throw ArgumentError(errors.join(', '));
    }
  }
}
