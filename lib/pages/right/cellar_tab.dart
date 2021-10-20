import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/pages/right/shelf_right.dart';
import 'package:mywine/shelf.dart';

class CellarTab extends StatefulWidget {
  const CellarTab({Key? key}) : super(key: key);

  @override
  _CellarTabState createState() => _CellarTabState();
}

class _CellarTabState extends State<CellarTab> {
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
                      child: DrawCellar(cellarId: cellar.id),
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
    return MainContainer(
      title: "Mes caves",
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
                snapshot: MyDatabase.getCellars(context: context),
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
                  "${MyDatabase.countFreeWines(context: context).toString()} bouteilles en vrac"
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: MyDatabase.getFreeWines(context: context)
                      .map<Widget>((freeWines) {
                    Wine wine = freeWines["wine"] as Wine;
                    int freeQuantity = freeWines["freeQuantity"] as int;
                    Map<String, dynamic>? enhancedWine =
                        MyDatabase.getEnhancedWineById(
                            context: context, wineId: wine.id);
                    if (enhancedWine == null) return Container();

                    return WineItem(
                      enhancedWine: enhancedWine,
                      freeQuantity: freeQuantity,
                      expandable: true,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          //Slide under the fab
          SizedBox(
            height: 110,
          ),
        ],
      ),
    );
  }
}
