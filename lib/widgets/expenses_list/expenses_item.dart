import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Icon(categoryIcons[expense.category],
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                const SizedBox(
                  width: 8,
                ),
                Text(expense.formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium)
              ],
            )
          ],
        ),
      ),
    );
  }
}
