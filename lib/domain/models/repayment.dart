import 'package:json_annotation/json_annotation.dart';

part 'repayment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Repayment {
  final String id;
  final String transactionId;
  final int amount;
  final DateTime when;
  final DateTime createdAt;

  Repayment({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.when,
    required this.createdAt,
  }) : assert(amount > 0, 'Amount must be positive'),
        assert(
          !when.isAfter(DateTime.now()),
          'Repayment date cannot be in the future',
        );

  factory Repayment.fromJson(Map<String, dynamic> json) =>
      _$RepaymentFromJson(json);

  Map<String, dynamic> toJson() => _$RepaymentToJson(this);

  Repayment copyWith({
    String? id,
    String? transactionId,
    int? amount,
    DateTime? when,
    DateTime? createdAt,
  }) {
    return Repayment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      when: when ?? this.when,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
