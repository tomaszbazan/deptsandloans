import 'package:deptsandloans/data/models/transaction_status.dart';
import 'package:deptsandloans/presentation/widgets/archive_section.dart';
import 'package:deptsandloans/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/app_fixture.dart';
import '../../fixtures/transaction_fixture.dart';
import '../../mocks/mock_repayment_repository.dart';

void main() {
  group('ArchiveSection', () {
    late MockRepaymentRepository mockRepaymentRepository;

    setUp(() {
      mockRepaymentRepository = MockRepaymentRepository();
    });

    testWidgets('does not render when no completed transactions', (tester) async {
      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: [], repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets('renders collapsed by default with completed transactions', (tester) async {
      final completedTransactions = [TransactionFixture.createTransaction(id: 1, name: 'Completed 1', status: TransactionStatus.completed)];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.text('Archive (1)'), findsOneWidget);
      expect(find.byIcon(Icons.archive_outlined), findsOneWidget);
      expect(find.byType(TransactionListItem), findsNothing);
    });

    testWidgets('displays correct count of completed transactions', (tester) async {
      final completedTransactions = [
        TransactionFixture.createTransaction(id: 1, name: 'Completed 1', status: TransactionStatus.completed),
        TransactionFixture.createTransaction(id: 2, name: 'Completed 2', status: TransactionStatus.completed),
        TransactionFixture.createTransaction(id: 3, name: 'Completed 3', status: TransactionStatus.completed),
      ];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Archive (3)'), findsOneWidget);
    });

    testWidgets('expands to show completed transactions when tapped', (tester) async {
      final completedTransactions = [
        TransactionFixture.createTransaction(id: 1, name: 'Completed 1', status: TransactionStatus.completed),
        TransactionFixture.createTransaction(id: 2, name: 'Completed 2', status: TransactionStatus.completed),
      ];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsNothing);

      await tester.tap(find.text('Archive (2)'));
      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsNWidgets(2));
      expect(find.text('Completed 1'), findsOneWidget);
      expect(find.text('Completed 2'), findsOneWidget);
    });

    testWidgets('collapses when tapped again', (tester) async {
      final completedTransactions = [TransactionFixture.createTransaction(id: 1, name: 'Completed 1', status: TransactionStatus.completed)];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive (1)'));
      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsOneWidget);

      await tester.tap(find.text('Archive (1)'));
      await tester.pumpAndSettle();

      expect(find.byType(TransactionListItem), findsNothing);
    });

    testWidgets('archived transactions are read-only', (tester) async {
      final transaction = TransactionFixture.createTransaction(id: 1, name: 'Completed', status: TransactionStatus.completed);
      final completedTransactions = [transaction];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive (1)'));
      await tester.pumpAndSettle();

      final transactionItem = tester.widget<TransactionListItem>(find.byType(TransactionListItem));
      expect(transactionItem.onTap, isNull);
    });

    testWidgets('displays transactions with reduced opacity', (tester) async {
      final completedTransactions = [TransactionFixture.createTransaction(id: 1, name: 'Completed 1', status: TransactionStatus.completed)];

      await tester.pumpWidget(
        AppFixture.createDefaultApp(
          Scaffold(
            body: ArchiveSection(completedTransactions: completedTransactions, repaymentRepository: mockRepaymentRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Archive (1)'));
      await tester.pumpAndSettle();

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, 0.7);
    });
  });
}
