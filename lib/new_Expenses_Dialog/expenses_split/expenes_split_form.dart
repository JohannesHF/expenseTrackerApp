import 'package:expense_tracker/models/split_manager.dart';
import 'package:expense_tracker/new_Expenses_Dialog/expenses_split/form_body.dart';
import 'package:expense_tracker/new_Expenses_Dialog/expenses_split/form_header.dart';
import 'package:flutter/material.dart';

class ExpensesSplitForm extends StatefulWidget {
  final SplitManager splitManager;

  const ExpensesSplitForm({super.key, required this.splitManager});

  @override
  State<ExpensesSplitForm> createState() => _ExpensesSplitFormState();
}

class _ExpensesSplitFormState extends State<ExpensesSplitForm> {
  bool expanded = false;

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                offset: const Offset(0.0, 2.0),
                blurRadius: 2.0)
          ]),
      child: Column(
        children: [
          FormHeader(
              expanded: expanded,
              onExpand: toggleExpansion,
              splitManager: widget.splitManager),
          if (expanded)
            FormBody(
              splitManager: widget.splitManager,
            )
        ],
      ),
    );
  }
}
