import 'package:deptsandloans/core/notifications/models/notification_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationPayload', () {
    test('toJson serializes correctly', () {
      const payload = NotificationPayload(transactionId: '123', transactionType: 'debt', transactionName: 'John Doe', remainingAmount: 150.50, currency: 'PLN');

      final json = payload.toJson();

      expect(json['transactionId'], '123');
      expect(json['transactionType'], 'debt');
      expect(json['transactionName'], 'John Doe');
      expect(json['remainingAmount'], 150.50);
      expect(json['currency'], 'PLN');
    });

    test('fromJson deserializes correctly', () {
      final json = {'transactionId': '456', 'transactionType': 'loan', 'transactionName': 'Jane Smith', 'remainingAmount': 200.75, 'currency': 'EUR'};

      final payload = NotificationPayload.fromJson(json);

      expect(payload.transactionId, '456');
      expect(payload.transactionType, 'loan');
      expect(payload.transactionName, 'Jane Smith');
      expect(payload.remainingAmount, 200.75);
      expect(payload.currency, 'EUR');
    });

    test('toJsonString creates valid JSON string', () {
      const payload = NotificationPayload(transactionId: '789', transactionType: 'debt', transactionName: 'Test User', remainingAmount: 99.99, currency: 'USD');

      final jsonString = payload.toJsonString();

      expect(jsonString, contains('789'));
      expect(jsonString, contains('debt'));
      expect(jsonString, contains('Test User'));
      expect(jsonString, contains('99.99'));
      expect(jsonString, contains('USD'));
    });

    test('fromJsonString parses valid JSON string', () {
      const jsonString = '{"transactionId":"999","transactionType":"loan","transactionName":"Another User","remainingAmount":50.25,"currency":"GBP"}';

      final payload = NotificationPayload.fromJsonString(jsonString);

      expect(payload.transactionId, '999');
      expect(payload.transactionType, 'loan');
      expect(payload.transactionName, 'Another User');
      expect(payload.remainingAmount, 50.25);
      expect(payload.currency, 'GBP');
    });

    test('round-trip serialization preserves data', () {
      const original = NotificationPayload(transactionId: 'round-trip', transactionType: 'debt', transactionName: 'Round Trip Test', remainingAmount: 12345.67, currency: 'PLN');

      final jsonString = original.toJsonString();
      final deserialized = NotificationPayload.fromJsonString(jsonString);

      expect(deserialized.transactionId, original.transactionId);
      expect(deserialized.transactionType, original.transactionType);
      expect(deserialized.transactionName, original.transactionName);
      expect(deserialized.remainingAmount, original.remainingAmount);
      expect(deserialized.currency, original.currency);
    });
  });
}
