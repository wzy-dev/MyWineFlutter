import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/shelf.dart';

class StockAddonForCellar {
  StockAddonForCellar({
    required this.toStockWine,
    required this.selectedCoors,
    required this.onPress,
    required this.onReset,
  });

  final Wine toStockWine;
  List<Map<String, dynamic>> selectedCoors;
  final Function onPress;
  final Function onReset;
}

class StockCellarArguments {
  StockCellarArguments({required this.toStockWine});

  final Wine toStockWine;
}

class StockCellar extends StatefulWidget {
  const StockCellar({Key? key, required this.toStockWine}) : super(key: key);

  final Wine toStockWine;

  @override
  _StockCellarState createState() => _StockCellarState();
}

class _StockCellarState extends State<StockCellar> {
  late List<Cellar> _cellars;
  late StockAddonForCellar _stockAddonForCellar;

  @override
  void initState() {
    _stockAddonForCellar = StockAddonForCellar(
      toStockWine: widget.toStockWine,
      selectedCoors: [],
      onPress: (Map<String, dynamic> coorPressed, bool isEvenSelected) {
        setState(() {
          !isEvenSelected &&
                  _stockAddonForCellar.selectedCoors.length <
                      MyDatabase.countFreeWineById(
                          context: context,
                          wineId: _stockAddonForCellar.toStockWine.id,
                          listen: false)
              ? _stockAddonForCellar.selectedCoors.add({
                  "x": coorPressed["coor"]["x"],
                  "y": coorPressed["coor"]["y"],
                  "blockId": coorPressed["blockId"]
                })
              : _stockAddonForCellar.selectedCoors.removeWhere((e) =>
                  e["x"] == coorPressed["coor"]["x"] &&
                  e["y"] == coorPressed["coor"]["y"] &&
                  e["blockId"] == coorPressed["blockId"]);
        });
      },
      onReset: () => setState(() => _stockAddonForCellar.selectedCoors = []),
    );
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
                        stockAddonForCellar: _stockAddonForCellar,
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
    _cellars = MyDatabase.getCellars(context: context);

    return MainContainer(
      title: Text("Placer mes bouteilles"),
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
            StockWineCard(
              enhancedWine: MyDatabase.getEnhancedWineById(
                  context: context,
                  wineId: _stockAddonForCellar.toStockWine.id,
                  listen: false)!,
              selectedCoors: _stockAddonForCellar.selectedCoors,
              resetCoors: () => setState(() => _stockAddonForCellar.onReset()),
            ),
          ],
        ),
      ),
    );
  }
}

class StockWineCard extends StatelessWidget {
  const StockWineCard({
    Key? key,
    required this.enhancedWine,
    required this.selectedCoors,
    required this.resetCoors,
  }) : super(key: key);

  final Map<String, dynamic> enhancedWine;
  final List<Map<String, dynamic>> selectedCoors;
  final Function resetCoors;

  @override
  Widget build(BuildContext context) {
    return ActionCard(
        margin: const EdgeInsets.all(14),
        enhancedWine: enhancedWine,
        leftWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_outlined,
              color: Theme.of(context).hintColor,
              size: 25,
            ),
            SizedBox(height: 8),
            Text(
                "${selectedCoors.length} / ${MyDatabase.countFreeWineById(context: context, wineId: enhancedWine["id"]).toString()}",
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
        listActions: [
          CustomElevatedButton(
            title: "Placer ${selectedCoors.length} bouteilles",
            icon: Icon(Icons.task_alt_outlined),
            onPress: () {
              bool isTheLast = selectedCoors.length /
                      MyDatabase.countFreeWineById(
                          context: context,
                          wineId: enhancedWine["id"],
                          listen: false) ==
                  1;

              Future.wait(selectedCoors.map((coor) {
                Position position = InitializerModel.initPosition(
                  block: coor["blockId"],
                  wine: enhancedWine["id"],
                  x: coor["x"],
                  y: coor["y"],
                );
                position.enabled = true;

                return MyActions.addPosition(
                  context: context,
                  position: position,
                );
              })).then((value) {
                resetCoors();
                if (isTheLast)
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(
                    "/cellar",
                    (_) => false,
                  );
              });
            },
            backgroundColor: Theme.of(context).hintColor,
          ),
          CustomFlatButton(
            title: "Arrêter le tri",
            icon: Icon(Icons.clear_outlined),
            onPress: () => Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(
              "/cellar",
              (_) => false,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          CustomFlatButton(
            title: "Voir la fiche de ce vin",
            icon: Icon(Icons.info_outline),
            onPress: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                "/wine",
                arguments: WineDetailsArguments(wineId: enhancedWine["id"]),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ]);
  }
}
