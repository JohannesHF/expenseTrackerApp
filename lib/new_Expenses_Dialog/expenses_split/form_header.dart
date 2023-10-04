import 'package:flutter/material.dart';
import '../../models/split_manager.dart';

class FormHeader extends StatefulWidget {
  final bool expanded;
  final void Function() onExpand;
  final SplitManager splitManager;

  const FormHeader(
      {super.key,
      required this.expanded,
      required this.onExpand,
      required this.splitManager});

  @override
  State<FormHeader> createState() => _FormHeaderState();
}

class _FormHeaderState extends State<FormHeader> {
  void splitParticipantsChangeCallback() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.splitManager.registerSplitParticipantsChangeCallback(
        splitParticipantsChangeCallback);
    super.dispose();
  }

  @override
  void initState() {
    widget.splitManager.registerSplitParticipantsChangeCallback(
        splitParticipantsChangeCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          size: 35,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.splitManager.funder.person.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              'paid for ${widget.splitManager.borrowersNames.join(',')}',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        const Spacer(),
        IconButton(
          icon: Icon(widget.expanded
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_left),
          onPressed: widget.onExpand,
        )
      ],
    );
  }
}
