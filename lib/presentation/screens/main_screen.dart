import 'package:deptsandloans/data/models/transaction_type.dart';
import 'package:deptsandloans/data/repositories/repayment_repository.dart';
import 'package:deptsandloans/data/repositories/transaction_repository.dart';
import 'package:deptsandloans/l10n/app_localizations.dart';
import 'package:deptsandloans/presentation/widgets/debts_list.dart';
import 'package:deptsandloans/presentation/widgets/loans_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final TransactionRepository transactionRepository;
  final RepaymentRepository repaymentRepository;
  final int initialIndex;

  const MainScreen({required this.transactionRepository, required this.repaymentRepository, this.initialIndex = 0, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TransactionType get _currentTransactionType {
    return _tabController.index == 0 ? TransactionType.debt : TransactionType.loan;
  }

  void _onAddTransaction() {
    final type = _currentTransactionType;
    context.push('/transaction/new?type=${type == TransactionType.debt ? 'debt' : 'loan'}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.myDebts, icon: const Icon(Icons.money_off)),
            Tab(text: l10n.myLoans, icon: const Icon(Icons.attach_money)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DebtsList(transactionRepository: widget.transactionRepository, repaymentRepository: widget.repaymentRepository),
          LoansList(transactionRepository: widget.transactionRepository, repaymentRepository: widget.repaymentRepository),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddTransaction,
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? l10n.addDebt : l10n.addLoan),
      ),
    );
  }
}
