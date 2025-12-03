import 'dart:convert';

class NotificationPayload {
  final String transactionId;
  final String transactionType;
  final String transactionName;
  final double remainingAmount;
  final String currency;

  const NotificationPayload({required this.transactionId, required this.transactionType, required this.transactionName, required this.remainingAmount, required this.currency});

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'transactionType': transactionType,
    'transactionName': transactionName,
    'remainingAmount': remainingAmount,
    'currency': currency,
  };

  factory NotificationPayload.fromJson(Map<String, dynamic> json) => NotificationPayload(
    transactionId: json['transactionId'] as String,
    transactionType: json['transactionType'] as String,
    transactionName: json['transactionName'] as String,
    remainingAmount: (json['remainingAmount'] as num).toDouble(),
    currency: json['currency'] as String,
  );

  String toJsonString() => jsonEncode(toJson());

  factory NotificationPayload.fromJsonString(String jsonString) => NotificationPayload.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
