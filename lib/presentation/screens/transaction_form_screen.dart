import 'package:deptsandloans/core/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionFormScreen extends StatelessWidget {
  final DatabaseService databaseService;
  final String? transactionId;
  final String? transactionType;

  const TransactionFormScreen({
    required this.databaseService,
    this.transactionId,
    this.transactionType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEditMode = transactionId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Transaction' : 'New Transaction',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              isEditMode
                  ? 'Transaction Form (Edit Mode)'
                  : 'Transaction Form (New)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (transactionId != null)
              Text(
                'Transaction ID: $transactionId',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (transactionType != null)
              Text(
                'Type: $transactionType',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            Text(
              'Placeholder for transaction form',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
