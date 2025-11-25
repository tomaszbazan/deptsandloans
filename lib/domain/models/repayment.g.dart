// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repayment _$RepaymentFromJson(Map<String, dynamic> json) => Repayment(
  id: json['id'] as String,
  transactionId: json['transaction_id'] as String,
  amount: (json['amount'] as num).toInt(),
  when: DateTime.parse(json['when'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RepaymentToJson(Repayment instance) => <String, dynamic>{
  'id': instance.id,
  'transaction_id': instance.transactionId,
  'amount': instance.amount,
  'when': instance.when.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
