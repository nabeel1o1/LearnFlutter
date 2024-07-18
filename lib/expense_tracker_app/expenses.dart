import 'package:flutter/material.dart';
import 'package:flutteroid_app/expense_tracker_app/widgets/add_expense.dart';
import 'package:flutteroid_app/expense_tracker_app/widgets/chart/Chart.dart';
import 'package:flutteroid_app/expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:flutteroid_app/expense_tracker_app/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  void Function(Expense expense)? addExpense;

  void _onAddExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = expenses.indexOf(expense);
    setState(() {
      expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              expenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  final List<Expense> expenses = [
    Expense(
        title: 'Flutter course',
        amount: 19.99,
        dateTime: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.99,
        dateTime: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddExpense(_onAddExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: expenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: expenses),
                ),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
