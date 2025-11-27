import 'package:isar_community/isar.dart';
import 'currency.dart';
import 'transaction_status.dart';
import 'transaction_type.dart';

part 'transaction.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late TransactionType type;

  late String name;

  late int amount;

  @Enumerated(EnumType.name)
  late Currency currency;

  String? description;

  DateTime? dueDate;

  @Enumerated(EnumType.name)
  late TransactionStatus status;

  late DateTime createdAt;

  late DateTime updatedAt;

  Transaction();

  double get amountInMainUnit => amount / 100.0;

  bool get isOverdue {
    if (dueDate == null || status == TransactionStatus.completed) {
      return false;
    }
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isActive => status == TransactionStatus.active;

  bool get isCompleted => status == TransactionStatus.completed;

  void validate() {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Name must not be empty');
    }

    if (amount <= 0) {
      errors.add('Amount must be positive');
    }

    if (description != null && description!.length > 200) {
      errors.add('Description must not exceed 200 characters');
    }

    if (dueDate != null && dueDate!.isBefore(DateTime.now())) {
      errors.add('Due date must be in the future');
    }

    if (errors.isNotEmpty) {
      throw ArgumentError(errors.join(', '));
    }
  }
}
