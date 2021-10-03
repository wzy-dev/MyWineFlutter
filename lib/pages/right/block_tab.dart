import 'package:flutter/material.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

class ScreenArguments {
  final DrawBlock drawBlock;

  ScreenArguments(this.drawBlock);
}

class BlockTab extends StatefulWidget {
  const BlockTab({Key? key}) : super(key: key);

  @override
  State<BlockTab> createState() => _BlockTabState();
}

class _BlockTabState extends State<BlockTab> {
  Map<String, dynamic>? _enhancedWine;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    DrawBlock _originBlock = args.drawBlock;
    final int _sizeCell = 40;

    return MainContainer(
      title: "Mes caves",
      child: ListView(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        children: [
          Container(
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
                          tag: "block${_originBlock.blockId}",
                          child: Container(
                            width: _originBlock.nbColumn.toDouble() * _sizeCell,
                            height: _originBlock.nbLine.toDouble() * _sizeCell,
                            child: Material(
                              type: MaterialType.transparency,
                              child: DrawBlock(
                                blockId: _originBlock.blockId,
                                nbColumn: _originBlock.nbColumn,
                                nbLine: _originBlock.nbLine,
                                onPress: (String id) {
                                  setState(() {
                                    _enhancedWine =
                                        MyDatabase.getEnhancedWineById(
                                            context: context, wineId: id);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: [Text(_enhancedWine?["appellation"].name ?? "null")],
            ),
          ),
        ],
      ),
    );
  }
}
