import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

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
    final blocks = MyDatabase.getBlocks(context: context);

    return _drawBlock(
        context: context,
        blocks: blocks.where((block) => block.cellar == cellarId).toList());
  }

  Widget _drawBlock(
      {required BuildContext context, required List<Block> blocks}) {
    Map lineExtremity =
        CustomMethods.getExtremity(list: blocks, propertyToCompare: "y");

    Map columnExtremity =
        CustomMethods.getExtremity(list: blocks, propertyToCompare: "x");

    List<Row> rows = [];

    for (var y = lineExtremity["max"]; y >= lineExtremity["min"]; y--) {
      List<Widget> cells = [];

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
          DrawBlock _drawBlock = DrawBlock(
            blockId: cell.id,
            nbLine: cell.nbLine,
            nbColumn: cell.nbColumn,
            sizeCell: sizeCell,
          );
          cells.add(
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, "/block",
                      arguments: ScreenArguments(_drawBlock)),
                  child: Padding(
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
                          child: Hero(
                            transitionOnUserGestures: true,
                            child: Material(child: _drawBlock),
                            tag: "block${cell.id}",
                          ),
                        ),
                      ),
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
