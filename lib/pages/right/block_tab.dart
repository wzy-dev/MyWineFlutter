import 'package:flutter/material.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

class ScreenArguments {
  final DrawBlock drawBlock;

  ScreenArguments(this.drawBlock);
}

class BlockTab extends StatelessWidget {
  const BlockTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    DrawBlock _originBlock = args.drawBlock;
    DrawBlock _customDrawBlock = DrawBlock(
      blockId: _originBlock.blockId,
      nbLine: _originBlock.nbLine,
      nbColumn: _originBlock.nbColumn,
      sizeCell: 40,
    );

    ShaderMask _shaderMask({required Widget child}) {
      return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Colors.white,
              Color.fromRGBO(0, 0, 0, 0.5),
              Color.fromRGBO(0, 0, 0, 0),
              Color.fromRGBO(0, 0, 0, 0),
              Color.fromRGBO(0, 0, 0, 0.5),
              Colors.white,
              Colors.white
            ],
            stops: [0.0, 0.01, 0.03, 0.05, 0.95, 0.97, 0.99, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: child,
      );
    }

    return MainContainer(
      title: "Mes caves",
      child: ListView(
        padding: const EdgeInsets.all(15),
        shrinkWrap: true,
        children: [
          Container(
            width: double.infinity,
            child: ShadowBox(
              child: _shaderMask(
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Hero(
                                transitionOnUserGestures: true,
                                child: Material(child: _customDrawBlock),
                                tag: "block${_originBlock.blockId}"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
