import 'package:flutter/material.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final DatabaseService databaseService;

  const HomeScreen({required this.databaseService, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.welcome),
            const SizedBox(height: 16),
            Text(
              databaseService.isInitialized ? l10n.databaseReady : l10n.databaseNotInitialized,
              style: TextStyle(color: databaseService.isInitialized ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(onPressed: () => context.push('/transaction/new?type=debt'), icon: const Icon(Icons.add), label: const Text('Add New Transaction')),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: () => context.push('/transaction/123'), icon: const Icon(Icons.visibility), label: const Text('View Sample Transaction')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push('/transaction/new'), child: const Icon(Icons.add)),
    );
  }
}
