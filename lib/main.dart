import 'package:flutter/material.dart';
import 'package:deptsandloans/core/database/database_service.dart';
import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final databaseService = DatabaseService();
    await databaseService.initialize();

    developer.log('Application starting with database initialized', name: 'main');

    runApp(DeptsAndLoansApp(databaseService: databaseService));
  } catch (e, stackTrace) {
    developer.log('Failed to initialize application', name: 'main', level: 1000, error: e, stackTrace: stackTrace);

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}

class DeptsAndLoansApp extends StatelessWidget {
  final DatabaseService databaseService;

  const DeptsAndLoansApp({required this.databaseService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debts and Loans',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(databaseService: databaseService),
    );
  }
}
