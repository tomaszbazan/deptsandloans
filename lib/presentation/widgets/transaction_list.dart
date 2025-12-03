import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final RepaymentRepository repaymentRepository;
  final Widget emptyState;
  final void Function(Transaction)? onTransactionTap;

  const TransactionList({required this.transactions, required this.repaymentRepository, required this.emptyState, this.onTransactionTap, super.key});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return emptyState;
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return FutureBuilder<double>(
          future: repaymentRepository.totalRepaid(transaction.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(height: 120, alignment: Alignment.center, child: const CircularProgressIndicator()),
              );
            }

            final remainingBalance = transaction.amountInMainUnit - snapshot.data!;
            return TransactionListItem(transaction: transaction, balance: remainingBalance, onTap: onTransactionTap != null ? () => onTransactionTap!(transaction) : null);
          },
        );
      },
    );
  }
}
