import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/pages/right/shelf_right.dart';
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
  int _countFreeWines = 0;

  @override
  void initState() {
    _searchedWine = widget.searchedWine;
    super.initState();
  }

  Widget _drawCellar({required List<Cellar> snapshot}) {
    return Container(
      child: Column(
        children: snapshot
            .map(
              (cellar) => Column(
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
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
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

    return MainContainer(
      title: Text(_cellars.length > 0 ? _cellars[0].name : "ras"),
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
                child: _drawCellar(
                  snapshot: _cellars,
                ),
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
                      ? Container(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            title: "Arrêter la recherche",
                            icon: Icon(Icons.search_off_outlined),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onPress: () => setState(() {
                              _searchedWine = null;
                            }),
                          ),
                        )
                      : Container(),
                  Container(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      title: "Voir tous mes vins",
                      icon: Icon(Icons.wine_bar_outlined),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPress: () => Navigator.of(context, rootNavigator: true)
                          .pushNamed("/winelist"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$_countFreeWines bouteille${_countFreeWines > 1 ? "s" : ""} en vrac"
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headline1,
                  ),
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
