import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class DrawBlock extends StatelessWidget {
  const DrawBlock({
    Key? key,
    required this.blockId,
    required this.nbLine,
    required this.nbColumn,
    this.sizeCell = 20.0,
  }) : super(key: key);

  final String blockId;
  final int nbLine;
  final int nbColumn;
  final double sizeCell;

  Widget _drawCircle({String? color}) {
    Color _color;
    switch (color) {
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
        decoration: BoxDecoration(
          border: Border.all(),
          color: _color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Row> rows = [];

    for (var y = nbLine; y >= 1; y--) {
      List<Container> cells = [];

      for (var x = 1; x <= nbColumn; x++) {
        String? color = Database.getColorByPosition(
            context: context, x: x, y: y, block: blockId);

        if (color == null) {
          cells.add(
            Container(
              child: Container(
                width: sizeCell,
                height: sizeCell,
                child: _drawCircle(),
              ),
            ),
          );
        } else {
          cells.add(
            Container(
              child: Container(
                width: sizeCell,
                height: sizeCell,
                child: Center(
                  child: _drawCircle(
                    color: color,
                  ),
                ),
              ),
            ),
          );
        }
      }

      rows.add(
        Row(children: cells),
      );
    }

    return Column(children: rows);
  }
}
