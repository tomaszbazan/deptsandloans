import 'package:deptsandloans/core/utils/currency_formatter.dart';
import 'package:deptsandloans/data/models/currency.dart';
import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  final double originalAmount;
  final double paidAmount;
  final double remainingAmount;
  final Currency currency;
  final bool isOverdue;

  const ProgressSection({required this.originalAmount, required this.paidAmount, required this.remainingAmount, required this.currency, required this.isOverdue, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = originalAmount > 0 ? paidAmount / originalAmount : 0.0;
    final percentage = (progress * 100).clamp(0.0, 100.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Repayment Progress', style: theme.textTheme.titleMedium),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isOverdue && percentage < 100 ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(isOverdue && percentage < 100 ? theme.colorScheme.error : theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AmountInfo(label: 'Paid', amount: paidAmount, currency: currency, color: theme.colorScheme.primary),
                _AmountInfo(
                  label: 'Remaining',
                  amount: remainingAmount,
                  currency: currency,
                  color: isOverdue && remainingAmount > 0 ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountInfo extends StatelessWidget {
  final String label;
  final double amount;
  final Currency currency;
  final Color color;

  const _AmountInfo({required this.label, required this.amount, required this.currency, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(
            amount: amount,
            currency: currency,
            locale: Localizations.localeOf(context),
          ),
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
