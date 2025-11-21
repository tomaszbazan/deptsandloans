import 'package:flutter/material.dart';
import 'package:deptsandloans/core/database/database_service.dart';

class HomeScreen extends StatelessWidget {
  final DatabaseService databaseService;

  const HomeScreen({required this.databaseService, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debts and Loans'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Debts and Loans'),
            const SizedBox(height: 16),
            Text('Database: ${databaseService.isInitialized ? "Ready" : "Not initialized"}', style: TextStyle(color: databaseService.isInitialized ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
