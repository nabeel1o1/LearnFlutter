import 'package:flutter/material.dart';
import 'package:flutteroid_app/expense_tracker_app/expenses.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const Expenses(),
  ),);
}
