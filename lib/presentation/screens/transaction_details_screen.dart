import 'package:deptsandloans/data/models/repayment.dart';
import 'package:deptsandloans/data/models/transaction.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/progress_section.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/repayment_history_section.dart';
import 'package:deptsandloans/presentation/widgets/transaction_details/transaction_info_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final RepaymentRepository repaymentRepository;
  final String transactionId;

  const TransactionDetailsScreen({required this.transactionRepository, required this.repaymentRepository, required this.transactionId, super.key});

  Future<_TransactionDetailsData> _loadData() async {
    final id = int.parse(transactionId);
    final transaction = await transactionRepository.getById(id);

    if (transaction == null) {
      throw Exception('Transaction not found');
    }

    final repayments = await repaymentRepository.getRepaymentsByTransactionId(id);
    repayments.sort((a, b) => b.when.compareTo(a.when));

    final totalRepaid = repayments.fold<double>(0.0, (sum, repayment) => sum + repayment.amountInMainUnit);
    final remainingBalance = (transaction.amountInMainUnit - totalRepaid).clamp(0.0, double.infinity);

    return _TransactionDetailsData(transaction: transaction, repayments: repayments, totalRepaid: totalRepaid, remainingBalance: remainingBalance);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/transaction/$transactionId/edit');
            },
          ),
        ],
      ),
      body: FutureBuilder<_TransactionDetailsData>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text('Transaction not found', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('The requested transaction could not be loaded.', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back), label: const Text('Go Back')),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final transaction = data.transaction;
          final isOverdue = transaction.isOverdue && data.remainingBalance > 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TransactionInfoSection(transaction: transaction, remainingBalance: data.remainingBalance),
                const SizedBox(height: 16),
                ProgressSection(
                  originalAmount: transaction.amountInMainUnit,
                  paidAmount: data.totalRepaid,
                  remainingAmount: data.remainingBalance,
                  currency: transaction.currency,
                  isOverdue: isOverdue,
                ),
                const SizedBox(height: 16),
                RepaymentHistorySection(repayments: data.repayments, currency: transaction.currency),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TransactionDetailsData {
  final Transaction transaction;
  final List<Repayment> repayments;
  final double totalRepaid;
  final double remainingBalance;

  _TransactionDetailsData({required this.transaction, required this.repayments, required this.totalRepaid, required this.remainingBalance});
}
