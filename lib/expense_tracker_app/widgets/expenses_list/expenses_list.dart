import 'package:flutter/material.dart';
import 'package:flutteroid_app/expense_tracker_app/models/expense.dart';
import 'package:flutteroid_app/expense_tracker_app/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.expenses, {super.key});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => ExpenseItem(expenses[index]));
  }
}
