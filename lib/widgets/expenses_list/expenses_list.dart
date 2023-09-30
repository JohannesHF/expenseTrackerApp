import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';
import '../expenses.dart';
import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onExpenseSwite});

  final void Function(Expense) onExpenseSwite;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => Dismissible(
            key: ValueKey(expenses[index]),
            onDismissed: (direction) => {onExpenseSwite(expenses[index])},
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              margin: Theme.of(context).cardTheme.margin,
            ),
            child: ExpenseItem(expenses[index])));
  }
}
