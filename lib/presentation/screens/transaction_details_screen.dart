import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionRepository transactionRepository;
  final String transactionId;

  const TransactionDetailsScreen({required this.transactionRepository, required this.transactionId, super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Transaction Details', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Transaction ID: $transactionId', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text('Placeholder for transaction details', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
