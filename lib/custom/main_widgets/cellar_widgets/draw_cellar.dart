import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mywine/shelf.dart';

class DrawCellar extends StatelessWidget {
  const DrawCellar({
    Key? key,
    required this.cellarId,
    this.resetSearch,
    this.sizeCell = 22.0,
    this.horizontalPadding = 15,
    this.verticalPadding = 15,
    this.marginBlock = 5.0,
    this.searchedWine,
    this.stockAddonForCellar,
  }) : super(key: key);

  final String cellarId;
  final Function? resetSearch;
  final double sizeCell;
  final double horizontalPadding;
  final double verticalPadding;
  final double marginBlock;
  final Wine? searchedWine;
  final StockAddonForCellar? stockAddonForCellar;

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
            searchedWine: searchedWine,
            toStockWine: stockAddonForCellar?.toStockWine ?? null,
            selectedCoors: stockAddonForCellar?.selectedCoors ?? [],
          );
          cells.add(
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => (stockAddonForCellar == null
                      ? Navigator.pushNamed(
                          context,
                          "/block",
                          arguments: BlockTabArguments(
                            drawBlock: _drawBlock,
                            cellarId: cellarId,
                            searchedWine: searchedWine,
                            resetSearch: resetSearch,
                          ),
                        )
                      : Navigator.pushNamed(
                          context,
                          "/stock/block",
                          arguments: StockBlockArguments(
                            drawBlock: _drawBlock,
                            cellarId: cellarId,
                            stockAddonForCellar: stockAddonForCellar!,
                          ),
                        )),
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
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: "block${cell.id}",
                          child: Container(
                            width: cell.nbColumn.toDouble() * sizeCell,
                            height: cell.nbLine.toDouble() * sizeCell,
                            child: Material(
                              type: MaterialType.transparency,
                              child: _drawBlock,
                            ),
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
          children: [
            SizedBox(
              width: horizontalPadding,
            ),
            ...cells,
            SizedBox(
              width: horizontalPadding,
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }

    return (rows.length > 1
        ? Container(
            child: Column(children: [
              SizedBox(height: verticalPadding),
              ...rows,
              SizedBox(height: verticalPadding),
            ]),
          )
        : Container());
  }
}
