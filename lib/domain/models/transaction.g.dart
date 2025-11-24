// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      description: json['description'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'name': instance.name,
      'amount': instance.amount,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'description': instance.description,
      'due_date': instance.dueDate?.toIso8601String(),
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.debt: 'debt',
  TransactionType.loan: 'loan',
};

const _$CurrencyEnumMap = {
  Currency.pln: 'pln',
  Currency.eur: 'eur',
  Currency.usd: 'usd',
  Currency.gbp: 'gbp',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.active: 'active',
  TransactionStatus.completed: 'completed',
};
