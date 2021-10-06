import 'package:flutter/material.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

class BlockTabArguments {
  final DrawBlock drawBlock;

  BlockTabArguments(this.drawBlock);
}

class BlockTab extends StatefulWidget {
  const BlockTab({Key? key}) : super(key: key);

  @override
  State<BlockTab> createState() => _BlockTabState();
}

class _BlockTabState extends State<BlockTab> {
  List<Map<String, dynamic>?> _enhancedWine = [];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BlockTabArguments;
    DrawBlock _originBlock = args.drawBlock;
    final int _sizeCell = 40;

    return MainContainer(
      title: "Mes caves",
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _drawBlock(_originBlock, _sizeCell, context),
            Expanded(
              child: Stack(
                children: _drawCarousel(),
              ),
            ),
            //Slide under the fab
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawCarousel() {
    List<Widget> result = [];

    for (int index = 1; index <= _enhancedWine.length; index++) {
      result.add(CarouselItem(enhancedWine: _enhancedWine, index: index));
    }

    return result;
  }

  Container _drawBlock(
      DrawBlock _originBlock, int _sizeCell, BuildContext context) {
    return Container(
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
                      child: DrawBlock(
                        blockId: _originBlock.blockId,
                        nbColumn: _originBlock.nbColumn,
                        nbLine: _originBlock.nbLine,
                        onPress: (String id) {
                          setState(() {
                            _enhancedWine.add(
                              MyDatabase.getEnhancedWineById(
                                context: context,
                                wineId: id,
                              ),
                            );
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
    );
  }
}

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    Key? key,
    required List<Map<String, dynamic>?> enhancedWine,
    required this.index,
  })  : _enhancedWine = enhancedWine,
        super(key: key);

  final List<Map<String, dynamic>?> _enhancedWine;
  final int index;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  bool isBuild = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        isBuild = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map? wine = widget._enhancedWine[widget.index - 1];

    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      left: widget.index == widget._enhancedWine.length
          ? isBuild
              ? 0
              : -MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width,
      top: 0,
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: wine != null
          ? Container(
              margin: const EdgeInsets.all(10),
              child: CustomCard(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${wine["domain"].name.toUpperCase()} ${wine["millesime"]}",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          SizedBox(height: 8),
                          Text(
                            wine["appellation"]["name"],
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    CustomElevatedButton(
                      title: "Voir la fiche de ce vin",
                      icon: Icon(Icons.info_outline),
                      onPress: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            "/wine",
                            arguments: WineDetailsArguments(wine["id"]));
                      },
                      backgroundColor: Theme.of(context).hintColor,
                    ),
                    CustomFlatButton(
                      title: "Trouver mes bouteilles",
                      icon: Icon(Icons.search_outlined),
                      onPress: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            "/wine",
                            arguments: WineDetailsArguments(wine["id"]));
                      },
                      backgroundColor: Color.fromRGBO(26, 143, 52, 1),
                    ),
                    CustomFlatButton(
                      title: "Boire cette bouteille",
                      icon: Icon(Icons.wine_bar_outlined),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    CustomFlatButton(
                      title: "Mettre cette bouteille en vrac",
                      icon: Icon(Icons.logout_outlined),
                      backgroundColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
