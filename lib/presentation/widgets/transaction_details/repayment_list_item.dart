import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepaymentListItem extends StatelessWidget {
  final Repayment repayment;
  final Currency currency;

  const RepaymentListItem({required this.repayment, required this.currency, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.payment, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          CurrencyFormatter.format(amount: repayment.amountInMainUnit, currency: currency, locale: Localizations.localeOf(context)),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat.yMd().add_jm().format(repayment.when), style: theme.textTheme.bodySmall),
      ),
    );
  }
}
