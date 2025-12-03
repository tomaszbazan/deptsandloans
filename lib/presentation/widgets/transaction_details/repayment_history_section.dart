import 'package:deptsandloans/data/models/currency.dart';
import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/repayment_list_item.dart';
import 'package:flutter/material.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';

class RepaymentHistorySection extends StatelessWidget {
  final List<Repayment> repayments;
  final Currency currency;

  const RepaymentHistorySection({required this.repayments, required this.currency, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.repaymentHistory, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            if (repayments.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.inbox, size: 48, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(height: 8),
                      Text(l10n.noRepaymentsYet, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              ...repayments.map((repayment) => RepaymentListItem(repayment: repayment, currency: currency)),
          ],
        ),
      ),
    );
  }
}
