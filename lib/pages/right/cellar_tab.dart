import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mywine/custom/main_widgets/search_card.dart';
import 'package:mywine/shelf.dart';

class CellarTabArguments {
  CellarTabArguments({this.searchedWine});

  final Wine? searchedWine;
}

class CellarTab extends StatefulWidget {
  const CellarTab({Key? key, this.searchedWine}) : super(key: key);

  final Wine? searchedWine;

  @override
  _CellarTabState createState() => _CellarTabState();
}

class _CellarTabState extends State<CellarTab> {
  late Wine? _searchedWine;
  late List<Map<String, Object>> _listFreeWines = [];
  late List<Cellar> _cellars;
  Cellar? _activeCellar;
  String? _activeCellarId;
  int _countFreeWines = 0;

  @override
  void initState() {
    _searchedWine = widget.searchedWine;
    super.initState();
  }

  Widget _drawCellar({required Cellar cellar}) {
    return Column(
      children: [
        ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DrawCellar(
              cellarId: cellar.id,
              searchedWine: _searchedWine,
              resetSearch: () => setState(() {
                _searchedWine = null;
              }),
              sizeCell: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future _drawSelectCellarBottomSheet() {
    return showBarModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              SizedBox(height: 30),
              ..._cellars.map((Cellar e) {
                return Column(
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _activeCellarId = e.id;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.name,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
              Container(
                width: double.infinity,
                child: Material(
                  child: InkWell(
                    onTap: () async {
                      Cellar? newCellar = await Navigator.of(context).pushNamed(
                        "/edit/cellar",
                        arguments: EditCellarArguments(),
                      ) as Cellar?;

                      if (newCellar != null) {
                        setState(() {
                          _activeCellar = newCellar;
                        });
                      }

                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: CustomFlatButton(
                        title: "Créer une nouvelle cave",
                        icon: Icon(Icons.add_outlined),
                        backgroundColor: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listFreeWines =
        MyDatabase.getFreeWines(context: context).where((freeWine) {
      Wine wine = freeWine["wine"] as Wine;

      return (_searchedWine == null ||
          (_searchedWine != null && wine.id == _searchedWine!.id));
    }).toList();

    _countFreeWines =
        MyDatabase.countWines(context: context, listWines: _listFreeWines);

    _cellars = MyDatabase.getCellars(context: context);

    if (_activeCellarId != null) {
      _activeCellar =
          _cellars.firstWhereOrNull((cellar) => cellar.id == _activeCellarId);
    }

    if (_activeCellar == null && _cellars.length > 0) {
      _activeCellar = _cellars[0];
    }

    return MainContainer(
      title: InkWell(
        onTap: () => _drawSelectCellarBottomSheet(),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(Icons.keyboard_arrow_down_outlined),
            ),
            Text(_activeCellar != null ? _activeCellar!.name : ""),
          ],
        ),
      ),
      action: InkWell(
        child: Text("Modifier"),
        onTap: _activeCellar != null
            ? () => Navigator.of(context).pushNamed("/edit/cellar",
                arguments: EditCellarArguments(cellar: _activeCellar!))
            : null,
      ),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: Colors.white,
              child: AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: _activeCellar != null
                    ? _drawCellar(
                        cellar: _activeCellar!,
                      )
                    : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _searchedWine != null
                      ? SearchCard(
                          context: context,
                          wineId: _searchedWine!.id,
                          stopSearchAction: () => setState(() {
                            _searchedWine = null;
                          }),
                        )
                      : Container(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            title: "Voir tous mes vins",
                            icon: Icon(Icons.wine_bar_outlined),
                            backgroundColor: Theme.of(context).primaryColor,
                            onPress: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed("/wine/list"),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  _countFreeWines > 0
                      ? Text(
                          "$_countFreeWines bouteille${_countFreeWines > 1 ? "s" : ""} en vrac"
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.headline1,
                        )
                      : Container(),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: _listFreeWines.map<Widget>((freeWines) {
                      Wine wine = freeWines["wine"] as Wine;
                      int freeQuantity = freeWines["freeQuantity"] as int;
                      Map<String, dynamic>? enhancedWine =
                          MyDatabase.getEnhancedWineById(
                              context: context, wineId: wine.id);
                      if (enhancedWine == null) return Container();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: WineItem(
                          enhancedWine: enhancedWine,
                          freeQuantity: freeQuantity,
                          expandable: true,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
