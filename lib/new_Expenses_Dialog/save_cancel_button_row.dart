import 'package:flutter/material.dart';

class SaveCancelButtonRow extends StatelessWidget {
  final void Function() onSave;
  final void Function() onCancel;

  const SaveCancelButtonRow(
      {super.key, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onCancel,
          child: const Text('cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
