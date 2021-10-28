import 'package:flutter/material.dart';

class DeleteChip extends StatelessWidget {
  const DeleteChip({
    Key? key,
    required this.label,
    required this.deleteAction,
    this.textColor,
    this.color,
  }) : super(key: key);

  final String label;
  final Function deleteAction;
  final Color? textColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      pressElevation: 2,
      padding: const EdgeInsets.all(5),
      side: BorderSide(),
      backgroundColor: color ?? Colors.transparent,
      label: Text(label, style: TextStyle(color: textColor)),
      deleteIcon: Icon(
        Icons.clear_outlined,
        size: 20,
        color: textColor,
      ),
      onDeleted: () => deleteAction(),
      onPressed: () => deleteAction(),
      deleteButtonTooltipMessage: "Supprimer",
      tooltip: "Supprimer",
    );
  }
}
