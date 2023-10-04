

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/new_Expenses_Dialog/new_expenses.dart';
import 'package:flutter/material.dart';

import '../models/person.dart';
import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 15.0,
        date: DateTime.now(),
        category: Category.work,
      paidFrom: Person.registeredPersons[0],
      paidFor: [Person.registeredPersons[0], Person.registeredPersons[1]]
    ),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure,
        paidFrom: Person.registeredPersons[1],
        paidFor: [Person.registeredPersons[1], Person.registeredPersons[0]]
    ),
  ];



  void _showAddExpensesOverlay() {
    showModalBottomSheet(
          showDragHandle: true,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (modalContext) => NewExpenses(
              onNewExpense: addExpense,
            ));
  }

  void addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
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
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text('no expenses found'));
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onExpenseSwite: removeExpense,
      );
    }
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpensesOverlay,
        child: const Icon(Icons.add),
      ),
      body: (width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
            )),
    );
  }
}
