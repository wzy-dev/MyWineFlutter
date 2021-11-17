import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class BlockTabArguments {
  BlockTabArguments(
      {required this.drawBlock,
      this.resetSearch,
      required this.cellarId,
      this.searchedWine});

  final DrawBlock drawBlock;
  final Function? resetSearch;
  final String cellarId;
  final Wine? searchedWine;
}

class BlockTab extends StatefulWidget {
  const BlockTab({Key? key, required this.arguments}) : super(key: key);

  final BlockTabArguments arguments;

  @override
  State<BlockTab> createState() => _BlockTabState();
}

class _BlockTabState extends State<BlockTab> {
  List<Map<String, dynamic>?> _enhancedWine = [];
  Map<String, int>? _selectedCoor;
  late Wine? _searchedWine;
  late final DrawBlock _originBlock;
  late final Function? _resetSearch;
  late final String _cellarId;
  final int _sizeCell = 40;

  @override
  void initState() {
    _originBlock = widget.arguments.drawBlock;
    _resetSearch = widget.arguments.resetSearch;
    _searchedWine = widget.arguments.searchedWine;
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
        child: ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          children: [
            _drawBlock(
                originBlock: _originBlock,
                sizeCell: _sizeCell,
                context: context,
                searchedWine: _searchedWine),
            _searchedWine != null
                ? Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    width: double.infinity,
                    child: CustomElevatedButton(
                      title: "Arrêter la recherche",
                      icon: Icon(Icons.search_off_outlined),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      onPress: () {
                        setState(() {
                          _searchedWine = null;
                        });
                        if (_resetSearch != null) _resetSearch!();
                      },
                    ),
                  )
                : Container(),
            Container(
              height: 306,
              child: Stack(
                children: _drawCarousel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawCarousel() {
    List<Widget> result = [];

    for (int index = 1; index <= _enhancedWine.length; index++) {
      result.add(CarouselItem(
          enhancedWine: _enhancedWine,
          hide: () => _enhancedWine.add({}),
          index: index,
          coor: _selectedCoor,
          blockId: _originBlock.blockId!,
          resetSelected: () => setState(() {
                _selectedCoor = null;
              })));
    }

    return result;
  }

  Widget _drawBlock(
      {required DrawBlock originBlock,
      required int sizeCell,
      required BuildContext context,
      Wine? searchedWine}) {
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
                        selectedCoor: _selectedCoor,
                        searchedWine: searchedWine,
                        onPress: (Map<String, dynamic> coorPressed,
                            bool isEvenSelected) {
                          if (isEvenSelected == true) return;
                          setState(() {
                            _selectedCoor = coorPressed["coor"];
                            _enhancedWine.add(
                              MyDatabase.getEnhancedWineById(
                                context: context,
                                listen: false,
                                wineId: coorPressed["id"],
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
  const CarouselItem(
      {Key? key,
      required this.enhancedWine,
      required this.index,
      required this.coor,
      required this.blockId,
      required this.resetSelected,
      required this.hide})
      : super(key: key);

  final List<Map<String, dynamic>?> enhancedWine;
  final int index;
  final Map<String, int>? coor;
  final String blockId;
  final Function resetSelected;
  final Function hide;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  bool _isBuild = false;
  Map? _wine;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _isBuild = true;
      });
    });
    _wine = widget.enhancedWine[widget.index - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 250),
      left: widget.index == widget.enhancedWine.length
          ? _isBuild
              ? 0
              : -MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width,
      top: 0,
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: _wine != null && _wine!["id"] != null
          ? Container(
              margin: const EdgeInsets.all(10),
              child: CustomCard(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_wine!["domain"].name.toUpperCase()} ${_wine!["millesime"]}",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              SizedBox(height: 8),
                              Text(
                                _wine!["appellation"]["name"],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        CustomElevatedButton(
                          title: "Voir la fiche de ce vin",
                          icon: Icon(Icons.info_outline),
                          onPress: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              "/wine",
                              arguments:
                                  WineDetailsArguments(wineId: _wine!["id"]),
                            );
                          },
                          backgroundColor: Theme.of(context).hintColor,
                        ),
                        CustomFlatButton(
                          title: "Trouver mes bouteilles",
                          icon: Icon(Icons.search_outlined),
                          onPress: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                            "/cellar",
                            (_) => false,
                            arguments: CellarTabArguments(
                              searchedWine: MyDatabase.getWineById(
                                context: context,
                                listen: false,
                                wineId: _wine!["id"],
                              ),
                            ),
                          ),
                          backgroundColor: Color.fromRGBO(26, 143, 52, 1),
                        ),
                        CustomFlatButton(
                          title: "Boire cette bouteille",
                          icon: Icon(Icons.wine_bar_outlined),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onPress: () {
                            widget.hide();
                            widget.resetSelected();
                            MyActions.drinkWine(
                              context: context,
                              wine: MyDatabase.getWineById(
                                  context: context,
                                  listen: false,
                                  wineId: _wine!["id"]),
                              position: widget.coor != null
                                  ? MyDatabase.getPositionByBlockIdAndCoor(
                                      context: context,
                                      listen: false,
                                      blockId: widget.blockId,
                                      coor: widget.coor!,
                                    )
                                  : null,
                            );
                          },
                        ),
                        CustomFlatButton(
                          title: "Mettre cette bouteille en vrac",
                          icon: Icon(Icons.logout_outlined),
                          backgroundColor: Colors.orange,
                          onPress: () {
                            widget.hide();
                            widget.resetSelected();
                            MyActions.deletePosition(
                              context: context,
                              position: widget.coor != null
                                  ? MyDatabase.getPositionByBlockIdAndCoor(
                                      context: context,
                                      listen: false,
                                      blockId: widget.blockId,
                                      coor: widget.coor!,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
