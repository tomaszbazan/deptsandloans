import 'package:json_annotation/json_annotation.dart';
import 'currency.dart';
import 'transaction_status.dart';
import 'transaction_type.dart';

part 'transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Transaction {
  final String id;
  final TransactionType type;
  final String name;
  final double amount;
  final Currency currency;
  final String? description;
  final DateTime? dueDate;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.name,
    required this.amount,
    required this.currency,
    this.description,
    this.dueDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(name.trim().isNotEmpty, 'Name cannot be empty'),
       assert(amount > 0, 'Amount must be positive'),
       assert(
         description == null || description.length <= 200,
         'Description must not exceed 200 characters',
       );

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  bool get isOverdue {
    if (dueDate == null || status == TransactionStatus.completed) {
      return false;
    }
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isActive => status == TransactionStatus.active;

  bool get isCompleted => status == TransactionStatus.completed;

  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? name,
    double? amount,
    Currency? currency,
    String? description,
    DateTime? dueDate,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
