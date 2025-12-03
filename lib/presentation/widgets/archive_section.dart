import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

class ArchiveSection extends StatelessWidget {
  final List<Transaction> completedTransactions;
  final RepaymentRepository repaymentRepository;
  final void Function(Transaction)? onTransactionTap;
  final bool initiallyExpanded;

  const ArchiveSection({required this.completedTransactions, required this.repaymentRepository, this.onTransactionTap, this.initiallyExpanded = false, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (completedTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 1,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(Icons.archive_outlined, color: Theme.of(context).colorScheme.primary),
        title: Text('${l10n.archive} (${completedTransactions.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        children: completedTransactions
            .map(
              (transaction) => FutureBuilder<double>(
                future: repaymentRepository.totalRepaid(transaction.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(height: 80, alignment: Alignment.center, child: const CircularProgressIndicator());
                  }

                  final remainingBalance = transaction.amountInMainUnit - snapshot.data!;
                  return Opacity(
                    opacity: 0.7,
                    child: TransactionListItem(transaction: transaction, balance: remainingBalance, onTap: onTransactionTap != null ? () => onTransactionTap!(transaction) : null),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
