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
  List<Map<String, dynamic>> _selectedCoors = [];
  late Wine? _searchedWine;
  late final DrawBlock _originBlock;
  late final Function? _resetSearch;
  late final String _cellarId;
  final int _sizeCell = 40;
  bool _selectMultiple = false;

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
          coors: _selectedCoors,
          blockId: _originBlock.blockId!,
          resetSelected: () => setState(() {
                _selectedCoors = [];
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
                        selectedCoors: _selectedCoors,
                        searchedWine: searchedWine,
                        selectMultiple: _selectMultiple,
                        setSelectMultiple: (bool value) => setState(() {
                          _selectMultiple = value;

                          if (!value && _selectedCoors.length > 0) {
                            _selectedCoors = [_selectedCoors.last];
                          }
                        }),
                        onPress: (Map<String, dynamic> coorPressed,
                            bool isEvenSelected) {
                          if (_selectMultiple) {
                            setState(() {
                              isEvenSelected
                                  ? _selectedCoors.removeWhere((e) =>
                                      e["x"] == coorPressed["coor"]["x"] &&
                                      e["y"] == coorPressed["coor"]["y"] &&
                                      e["blockId"] == coorPressed["blockId"])
                                  : _selectedCoors.add({
                                      "x": coorPressed["coor"]["x"],
                                      "y": coorPressed["coor"]["y"],
                                      "blockId": coorPressed["blockId"]
                                    });
                              _selectedCoors.length > 0
                                  ? _enhancedWine.add(
                                      MyDatabase.getEnhancedWineById(
                                        context: context,
                                        listen: false,
                                        wineId: coorPressed["id"],
                                      ),
                                    )
                                  : _enhancedWine.add({});
                            });
                            return;
                          }

                          if (isEvenSelected == true) return;
                          setState(() {
                            _selectedCoors = [
                              {
                                "x": coorPressed["coor"]["x"],
                                "y": coorPressed["coor"]["y"],
                                "blockId": coorPressed["blockId"]
                              }
                            ];
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
  const CarouselItem({
    Key? key,
    required this.enhancedWine,
    required this.index,
    required this.blockId,
    required this.resetSelected,
    required this.hide,
    this.coors = const [],
  }) : super(key: key);

  final List<Map<String, dynamic>?> enhancedWine;
  final int index;
  final List<Map<String, dynamic>> coors;
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
                          title: widget.coors.length > 1
                              ? "Boire ces bouteilles"
                              : "Boire cette bouteille",
                          icon: Icon(Icons.wine_bar_outlined),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onPress: () {
                            widget.hide();
                            widget.resetSelected();
                            widget.coors.forEach((coor) {
                              MyActions.drinkWine(
                                context: context,
                                wine: MyDatabase.getWineById(
                                    context: context,
                                    listen: false,
                                    wineId: _wine!["id"]),
                                position:
                                    MyDatabase.getPositionByBlockIdAndCoor(
                                  context: context,
                                  listen: false,
                                  blockId: widget.blockId,
                                  coor: coor,
                                ),
                              );
                            });
                          },
                        ),
                        CustomFlatButton(
                          title: widget.coors.length > 1
                              ? "Mettre ces bouteilles en vrac"
                              : "Mettre cette bouteille en vrac",
                          icon: Icon(Icons.logout_outlined),
                          backgroundColor: Colors.orange,
                          onPress: () {
                            widget.hide();
                            widget.resetSelected();

                            widget.coors.forEach((coor) {
                              MyActions.deletePosition(
                                context: context,
                                position:
                                    MyDatabase.getPositionByBlockIdAndCoor(
                                  context: context,
                                  listen: false,
                                  blockId: widget.blockId,
                                  coor: coor,
                                ),
                              );
                            });
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
