import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/widgets/archive_section.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DebtsList extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final RepaymentRepository repaymentRepository;

  const DebtsList({required this.transactionRepository, required this.repaymentRepository, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder(
      future: transactionRepository.getByType(TransactionType.debt),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error)),
          );
        }

        final allTransactions = snapshot.data ?? [];
        final activeTransactions = allTransactions.where((t) => t.isActive).toList();
        final completedTransactions = allTransactions.where((t) => t.isCompleted).toList();

        if (allTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                Text(l10n.emptyDebts, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(l10n.addFirstDebt, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: activeTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Theme.of(context).colorScheme.outline),
                          const SizedBox(height: 16),
                          Text('All debts completed!', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text('Check archive below', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline)),
                        ],
                      ),
                    )
                  : TransactionList(
                      transactions: activeTransactions,
                      repaymentRepository: repaymentRepository,
                      onTransactionTap: (transaction) {
                        context.push('/transaction/${transaction.id}');
                      },
                      emptyState: const SizedBox.shrink(),
                    ),
            ),
            ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: repaymentRepository),
          ],
        );
      },
    );
  }
}
