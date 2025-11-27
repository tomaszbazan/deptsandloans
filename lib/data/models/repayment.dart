import 'package:isar_community/isar.dart';

part 'repayment.g.dart';

@Collection()
class Repayment {
  Id id = Isar.autoIncrement;

  @Index()
  late int transactionId;

  late int amount;

  @Index(composite: [CompositeIndex('transactionId')])
  late DateTime when;

  late DateTime createdAt;

  Repayment();

  double get amountInMainUnit => amount / 100.0;

  void validate() {
    final errors = <String>[];

    if (amount < 0) {
      errors.add('Amount cannot be negative');
    }

    if (when.isAfter(DateTime.now())) {
      errors.add('Repayment date cannot be in the future');
    }

    if (errors.isNotEmpty) {
      throw ArgumentError(errors.join(', '));
    }
  }
}
