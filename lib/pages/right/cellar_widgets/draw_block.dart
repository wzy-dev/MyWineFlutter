import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:collection/collection.dart';

class DrawBlock extends StatelessWidget {
  const DrawBlock({
    Key? key,
    required this.blockId,
    required this.nbLine,
    required this.nbColumn,
    this.onPress,
  }) : super(key: key);

  final String blockId;
  final int nbLine;
  final int nbColumn;
  final Function? onPress;

  Widget _drawCircle({required BuildContext context, String? wine}) {
    Color _color;
    switch (wine) {
      case "r":
        _color = Color.fromRGBO(219, 61, 77, 1);
        break;
      case "w":
        _color = Color.fromRGBO(248, 216, 114, 1);
        break;
      case "p":
        _color = Color.fromRGBO(255, 212, 196, 1);
        break;
      default:
        _color = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(),
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: onPress != null && wine != null ? () => onPress!(wine) : null,
          child: Container(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    List<Position> positions =
        MyDatabase.getPositionsByBlockId(context: context, blockId: blockId);

    for (var y = nbLine; y >= 1; y--) {
      List<Widget> cells = [];

      for (var x = 1; x <= nbColumn; x++) {
        Position? position = positions
            .firstWhereOrNull((position) => position.x == x && position.y == y);

        cells.add(
          Expanded(
            child: _drawCircle(
              context: context,
              wine: position?.wine ?? null,
            ),
          ),
        );
      }

      rows.add(
        Expanded(
          child: Row(
            children: cells,
          ),
        ),
      );
    }

    return Column(
      children: rows,
    );
  }
}
