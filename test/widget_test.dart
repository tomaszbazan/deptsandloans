import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deptsandloans/presentation/screens/home_screen.dart';
import 'mocks/mock_database_service.dart';

void main() {
  testWidgets('Home screen displays correctly', (WidgetTester tester) async {
    final mockDatabaseService = MockDatabaseService();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(databaseService: mockDatabaseService),
      ),
    );

    expect(find.text('Debts and Loans'), findsOneWidget);
    expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
    expect(find.text('Database: Ready'), findsOneWidget);
  });
}
