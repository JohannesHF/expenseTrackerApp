import 'dart:io';
import 'package:expense_tracker/new_Expenses_Dialog/expenses_split/expenes_split_form.dart';
import 'package:expense_tracker/new_Expenses_Dialog/save_cancel_button_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

import '../models/person.dart';
import '../models/split_manager.dart';

class NewExpenses extends StatefulWidget {
  final void Function(Expense) onNewExpense;

  const NewExpenses({super.key, required this.onNewExpense});

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final splitManager =
      SplitManager(splitsBetweenPersons: Person.registeredPersons);
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    showDatePicker(
            context: context,
            initialDate: now,
            firstDate: firstDate,
            lastDate: now)
        .then((value) {
      setState(() {
        _selectedDate = value;
      });
    });
  }

  void _refreshAmount(String amountStr){
    double? amount = double.tryParse(amountStr);
    amount ??= 0.0;
    splitManager.amount = amount;
  }

  void showAlertDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (alertDialogContext) => CupertinoAlertDialog(
                title: const Text('Input Invalid'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(alertDialogContext);
                      },
                      child: const Text('Okay'))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (alertDialogContext) => AlertDialog(
                title: const Text('Input Invalid'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(alertDialogContext);
                      },
                      child: const Text('Okay'))
                ],
              ));
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showAlertDialog();
      return;
    }
    List<SplitParticipant> borrowers = splitManager.borrowers;
    final newExpense = Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
        paidFrom: splitManager.funder.person,
        paidFor: List<Person>.generate(borrowers.length, (index) => borrowers[index].person));
    widget.onNewExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, keyboardSpace + 40),
      child: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constrains) {
          final maxWidth = constrains.maxWidth;
          return Column(
            children: [
              if (maxWidth < 600)
                TextField(
                  maxLength: 50,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    label: Text('Expense title'),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (maxWidth >= 600)
                    Expanded(
                      child: TextField(
                        maxLength: 50,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          label: Text('Expense title'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      onChanged: _refreshAmount,
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? ''
                            : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toString())))
                          .toList(),
                      onChanged: (category) {
                        if (category == null) return;
                        setState(() {
                          _selectedCategory = category;
                        });
                      }),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ExpensesSplitForm(
                splitManager: splitManager,
              ),
              const SizedBox(
                height: 20,
              ),
              SaveCancelButtonRow(
                  onSave: _submitExpenseData,
                  onCancel: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        }),
      ),
    );
  }
}
