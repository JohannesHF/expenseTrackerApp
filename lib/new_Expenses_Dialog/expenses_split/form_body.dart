import 'package:expense_tracker/models/split_manager.dart';
import 'package:expense_tracker/new_Expenses_Dialog/expenses_split/person_split_tile.dart';
import 'package:flutter/material.dart';

import '../../models/person.dart';

class FormBody extends StatelessWidget {
  final SplitManager splitManager;
  const FormBody({super.key, required this.splitManager});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            shrinkWrap: true,
            itemCount: Person.registeredPersons.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 6,
            ),
            itemBuilder: (BuildContext context, int index) => PersonSplitListTile(
              key: ValueKey(splitManager.splitParticipants[index].person.id),
              splitParticipant: splitManager.splitParticipants[index],
              //splitManager: splitManager
            ),
          ),
        )
      ],
    );
  }
}
