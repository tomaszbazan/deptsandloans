import 'package:flutter/material.dart';

void main() {
  runApp(const DeptsAndLoansApp());
}

class DeptsAndLoansApp extends StatelessWidget {
  const DeptsAndLoansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debts and Loans',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts and Loans'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Welcome to Debts and Loans'),
      ),
    );
  }
}
