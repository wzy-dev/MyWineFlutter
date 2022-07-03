import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class StockBlockArguments {
  StockBlockArguments({
    required this.drawBlock,
    required this.cellarId,
    required this.stockAddonForCellar,
  });

  final DrawBlock drawBlock;
  final String cellarId;
  final StockAddonForCellar stockAddonForCellar;
}

class StockBlock extends StatefulWidget {
  const StockBlock(
      {Key? key, required this.arguments, required this.stockAddonForCellar})
      : super(key: key);

  final StockBlockArguments arguments;
  final StockAddonForCellar stockAddonForCellar;

  @override
  State<StockBlock> createState() => _StockBlockState();
}

class _StockBlockState extends State<StockBlock> {
  late final DrawBlock _originBlock;
  late final String _cellarId;
  final int _sizeCell = 40;

  @override
  void initState() {
    _originBlock = widget.arguments.drawBlock;
    _cellarId = widget.arguments.cellarId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text(
          MyDatabase.getCellarById(context: context, cellarId: _cellarId)
                  ?.name ??
              "ras"),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _drawBlock(
              originBlock: _originBlock,
              sizeCell: _sizeCell,
              context: context,
            ),
            StockWineCard(
              enhancedWine: MyDatabase.getEnhancedWineById(
                  context: context,
                  wineId: _originBlock.toStockWine!.id,
                  listen: false)!,
              selectedCoors: widget.stockAddonForCellar.selectedCoors,
              resetCoors: () =>
                  setState(() => widget.stockAddonForCellar.onReset()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawBlock({
    required DrawBlock originBlock,
    required int sizeCell,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: Colors.white,
      child: AnimatedSize(
        duration: Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: "block${originBlock.blockId}",
                    child: Container(
                      width: originBlock.nbColumn.toDouble() * sizeCell,
                      height: originBlock.nbLine.toDouble() * sizeCell,
                      child: DrawBlock(
                        blockId: originBlock.blockId,
                        nbColumn: originBlock.nbColumn,
                        nbLine: originBlock.nbLine,
                        sizeCell: _sizeCell,
                        selectedCoors: widget.stockAddonForCellar.selectedCoors,
                        toStockWine: originBlock.toStockWine,
                        onPress: (Map<String, dynamic> coorPressed,
                                bool isEvenSelected) =>
                            setState(() => widget.stockAddonForCellar
                                .onPress(coorPressed, isEvenSelected)),
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
