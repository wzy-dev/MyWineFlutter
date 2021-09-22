import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

class DrawCellar extends StatelessWidget {
  const DrawCellar(
      {Key? key,
      required this.cellarId,
      this.sizeCell = 22.0,
      this.marginBlock = 5.0})
      : super(key: key);

  final String cellarId;
  final double sizeCell;
  final double marginBlock;

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

  double getAlignment(String? alignmentWord) {
    switch (alignmentWord) {
      case "flex-start":
        return -1;
      case "center":
        return 0;
      case "flex-end":
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Database.getBlocksByCellar(cellarId: cellarId),
        builder: (BuildContext context,
            AsyncSnapshot<List<QueryDocumentSnapshot>?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            // return Center(
            //   child: CircularProgressIndicator(
            //     color: Theme.of(context).primaryColor,
            //   ),
            // );
            return Container(
              height: 10,
            );

          List<QueryDocumentSnapshot> data = snapshot.data!;
          Map lineExtremity = getExtremity(list: data, propertyToCompare: "y");

          Map columnExtremity =
              getExtremity(list: data, propertyToCompare: "x");

          List<Row> rows = [];

          for (var y = lineExtremity["max"]; y >= lineExtremity["min"]; y--) {
            List<Padding> cells = [];

            for (var x = columnExtremity["min"];
                x <= columnExtremity["max"];
                x++) {
              QueryDocumentSnapshot<Object?>? cell = data.firstWhereOrNull(
                (element) => element["y"] == y && element["x"] == x,
              );

              Map nbColumnExtremity = getExtremity(
                  list: data.where((element) => element["x"] == x).toList(),
                  propertyToCompare: "nbColumn");
              Map nbLineExtremity = getExtremity(
                  list: data.where((element) => element["y"] == y).toList(),
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
                          (cell.data() as Map)["horizontalAlignment"] != null
                              ? getAlignment(cell["horizontalAlignment"])
                              : 0,
                          (cell.data() as Map)["verticalAlignment"] != null
                              ? getAlignment(cell["verticalAlignment"])
                              : 0,
                        ),
                        child: Container(
                          width: cell["nbColumn"].toDouble() * sizeCell,
                          height: cell["nbLine"].toDouble() * sizeCell,
                          child: DrawBlock(
                            cellarId: cellarId,
                            blockId: cell.id,
                            nbLine: cell["nbLine"],
                            nbColumn: cell["nbColumn"],
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
        });
  }
}
