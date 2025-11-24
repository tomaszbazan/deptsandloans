import 'package:flutter/material.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final DatabaseService databaseService;

  const HomeScreen({required this.databaseService, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.welcome),
            const SizedBox(height: 16),
            Text(
              databaseService.isInitialized
                  ? l10n.databaseReady
                  : l10n.databaseNotInitialized,
              style: TextStyle(
                color: databaseService.isInitialized ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
