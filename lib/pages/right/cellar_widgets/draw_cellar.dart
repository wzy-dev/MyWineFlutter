import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';

class DrawCellar extends StatelessWidget {
  const DrawCellar({
    Key? key,
    required this.cellarId,
    this.sizeCell = 22.0,
    this.marginBlock = 5.0,
  }) : super(key: key);

  final String cellarId;
  final double sizeCell;
  final double marginBlock;

  @override
  Widget build(BuildContext context) {
    final blocks = Provider.of<List<Block>>(context);

    return _drawBlock(blocks);
  }

  Widget _drawBlock(List<Block> blocks) {
    Map lineExtremity =
        CustomMethods.getExtremity(list: blocks, propertyToCompare: "y");

    Map columnExtremity =
        CustomMethods.getExtremity(list: blocks, propertyToCompare: "x");

    List<Row> rows = [];

    for (var y = lineExtremity["max"]; y >= lineExtremity["min"]; y--) {
      List<Padding> cells = [];

      for (var x = columnExtremity["min"]; x <= columnExtremity["max"]; x++) {
        Block? cell = blocks.firstWhereOrNull(
          (element) => element.y == y && element.x == x,
        );

        Map nbColumnExtremity = CustomMethods.getExtremity(
            list: blocks.where((element) => element.x == x).toList(),
            propertyToCompare: "nbColumn");
        Map nbLineExtremity = CustomMethods.getExtremity(
            list: blocks.where((element) => element.y == y).toList(),
            propertyToCompare: "nbLine");

        if (cell == null) {
          cells.add(
            Padding(
              padding: EdgeInsets.all(marginBlock),
              child: Container(
                width: (nbColumnExtremity["max"] * sizeCell).toDouble(),
                height: (nbLineExtremity["max"] * sizeCell).toDouble(),
              ),
            ),
          );
        } else {
          cells.add(
            Padding(
              padding: EdgeInsets.all(marginBlock),
              child: Container(
                width: (nbColumnExtremity["max"] * sizeCell).toDouble(),
                height: (nbLineExtremity["max"] * sizeCell).toDouble(),
                child: Align(
                  alignment: Alignment(
                    CustomMethods.getAlignment(cell.horizontalAlignment),
                    CustomMethods.getAlignment(cell.verticalAlignment),
                  ),
                  child: Container(
                    width: cell.nbColumn.toDouble() * sizeCell,
                    height: cell.nbLine.toDouble() * sizeCell,
                    child: DrawBlock(
                      blockId: cell.id,
                      nbLine: cell.nbLine,
                      nbColumn: cell.nbColumn,
                      sizeCell: sizeCell,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
      rows.add(
        Row(
          children: cells,
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }

    return Container(
      child: Column(children: rows),
    );
  }
}
