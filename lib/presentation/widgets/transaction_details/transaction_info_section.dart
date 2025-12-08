import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInfoSection extends StatelessWidget {
  final Transaction transaction;
  final double remainingBalance;

  const TransactionInfoSection({required this.transaction, required this.remainingBalance, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = transaction.isOverdue && remainingBalance > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(transaction.type == TransactionType.debt ? 'Debt' : 'Loan'),
                  backgroundColor: transaction.type == TransactionType.debt ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: transaction.type == TransactionType.debt ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer),
                ),
                const Spacer(),
                if (isOverdue)
                  Chip(
                    label: const Text('Overdue'),
                    backgroundColor: theme.colorScheme.error,
                    labelStyle: TextStyle(color: theme.colorScheme.onError),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(transaction.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.account_balance_wallet,
              label: 'Original Amount',
              value: CurrencyFormatter.format(
                amount: transaction.amountInMainUnit,
                currency: transaction.currency,
                locale: Localizations.localeOf(context),
              ),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.money,
              label: 'Remaining Balance',
              value: CurrencyFormatter.format(
                amount: remainingBalance,
                currency: transaction.currency,
                locale: Localizations.localeOf(context),
              ),
              valueColor: isOverdue ? theme.colorScheme.error : null,
            ),
            if (transaction.description != null && transaction.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.description, size: 20, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(transaction.description!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (transaction.dueDate != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.event, label: 'Due Date', value: DateFormat.yMd().format(transaction.dueDate!), valueColor: isOverdue ? theme.colorScheme.error : null),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.check_circle,
              label: 'Status',
              value: transaction.isCompleted ? 'Completed' : 'Active',
              valueColor: transaction.isCompleted ? theme.colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}
