import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final double balance;
  final VoidCallback? onTap;

  const TransactionListItem({required this.transaction, required this.balance, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(locale: Localizations.localeOf(context).toString(), symbol: transaction.currency.symbol, decimalDigits: 2);

    final isOverdue = transaction.isOverdue;
    final balanceDiffersFromAmount = balance != transaction.amountInMainUnit;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(transaction.name, style: theme.textTheme.titleLarge, overflow: TextOverflow.ellipsis),
                  ),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(12)),
                      child: Text(l10n.overdue, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onError)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.amount, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                      const SizedBox(height: 4),
                      Text(currencyFormat.format(transaction.amountInMainUnit), style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l10n.balance, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(balance),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: balanceDiffersFromAmount ? theme.colorScheme.primary : null,
                          fontWeight: balanceDiffersFromAmount ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (transaction.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: isOverdue ? theme.colorScheme.error : theme.colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.dueDate}: ${DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(transaction.dueDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: isOverdue ? theme.colorScheme.error : theme.colorScheme.outline),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
