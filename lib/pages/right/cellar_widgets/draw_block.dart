import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mywine/shelf.dart';

class DrawBlock extends StatelessWidget {
  const DrawBlock({
    Key? key,
    required this.cellarId,
    required this.blockId,
    required this.nbLine,
    required this.nbColumn,
    this.sizeCell = 20.0,
  }) : super(key: key);

  final String cellarId;
  final String blockId;
  final int nbLine;
  final int nbColumn;
  final double sizeCell;

  Map<String, int> getExtremity(
      {required List<dynamic> list, required String propertyToCompare}) {
    if (list.isNotEmpty) {
      list.sort((a, b) => a[propertyToCompare].compareTo(b[propertyToCompare]));
    }

    final Map<String, int> result = {
      "min": list.first[propertyToCompare],
      "max": list.last[propertyToCompare],
    };

    return result;
  }

  Future<Map?> _getColorOfWine(wineId) async {
    Map? wine = await Database.getWineById(wineId: wineId);

    return await Database.getAppellationById(
        appellationId: wine!["appellation"]);
  }

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
    return FutureBuilder(
        future:
            Database.getPositionsByBlock(cellarId: cellarId, blockId: blockId),
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Container();

          List<dynamic> data = snapshot.data!;

          List<TableRow> rows = [];

          for (var y = nbLine; y >= 1; y--) {
            List<TableCell> cells = [];

            for (var x = 1; x <= nbColumn; x++) {
              var cell = data.firstWhereOrNull(
                (element) => element["y"] == y && element["x"] == x,
              );

              if (cell == null || cell.id == null) {
                cells.add(
                  TableCell(
                    child: Container(
                      width: sizeCell,
                      height: sizeCell,
                      child: _drawCircle(),
                    ),
                  ),
                );
              } else {
                cells.add(
                  TableCell(
                    child: Container(
                      width: sizeCell,
                      height: sizeCell,
                      child: Center(
                        child: FutureBuilder(
                          future: _getColorOfWine(cell["wine"]),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map?> snapshotAppellation) {
                            if (snapshotAppellation.connectionState !=
                                ConnectionState.done) return _drawCircle();

                            return _drawCircle(
                                color: snapshotAppellation.data!["color"]);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
            rows.add(
              TableRow(children: cells),
            );
          }

          return Table(children: rows);
        });
  }
}
