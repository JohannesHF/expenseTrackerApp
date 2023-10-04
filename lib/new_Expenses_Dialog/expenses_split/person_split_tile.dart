import 'package:expense_tracker/models/split_manager.dart';
import 'package:flutter/material.dart';

class PersonSplitListTile extends StatefulWidget {
  const PersonSplitListTile({super.key, required this.splitParticipant});

  final SplitParticipant splitParticipant;

  @override
  State<PersonSplitListTile> createState() => _PersonSplitListTileState();
}

class _PersonSplitListTileState extends State<PersonSplitListTile> {
  void splitParticipantCallback(SplitParticipant splitParticipant) {
    setState(() {});
  }

  @override
  void initState() {
    widget.splitParticipant.registerCallback(splitParticipantCallback);
    super.initState();
  }

  @override
  void dispose() {
    widget.splitParticipant.removeCallback(splitParticipantCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = widget.splitParticipant.isFunder
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                offset: const Offset(0.0, 0.0),
                blurRadius: 4.0,
              ),
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          )
        : BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          );

    return GestureDetector(
      onTap: () {
        widget.splitParticipant.selectAsFunder();
      },
      child: Container(
        decoration: boxDecoration,
        child: Row(
          children: [
            Checkbox(
              value: widget.splitParticipant.isBorrower,
              onChanged: widget.splitParticipant.setAsBorrower,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(widget.splitParticipant.person.name,
                style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            Text(
              widget.splitParticipant.amountShare.toStringAsFixed(2),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              width: 30,
            )
          ],
        ),
      ),
    );
  }
}
