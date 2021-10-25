import 'package:flutter/material.dart';

class DeleteChip extends StatelessWidget {
  const DeleteChip({
    Key? key,
    required this.label,
    required this.deleteAction,
  }) : super(key: key);

  final String label;
  final Function deleteAction;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      pressElevation: 2,
      padding: const EdgeInsets.all(5),
      side: BorderSide(),
      backgroundColor: Colors.transparent,
      label: Text(label),
      deleteIcon: Icon(
        Icons.clear_outlined,
        size: 20,
      ),
      onDeleted: () => deleteAction(),
      onPressed: () => deleteAction(),
      deleteButtonTooltipMessage: "Supprimer",
      tooltip: "Supprimer",
    );
  }
}
