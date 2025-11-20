import 'package:flutter_test/flutter_test.dart';

import 'package:deptsandloans/main.dart';

void main() {
  testWidgets('App initializes with home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DeptsAndLoansApp());

    expect(find.text('Debts and Loans'), findsAtLeastNWidgets(1));
    expect(find.text('Welcome to Debts and Loans'), findsOneWidget);
  });
}
