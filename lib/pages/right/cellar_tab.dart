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
  // ShaderMask _shaderMask() {
  //   return ShaderMask(
  //     shaderCallback: (Rect rect) {
  //       return LinearGradient(
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         colors: [
  //           Colors.white,
  //           Colors.white,
  //           Color.fromRGBO(0, 0, 0, 0.5),
  //           Color.fromRGBO(0, 0, 0, 0),
  //           Color.fromRGBO(0, 0, 0, 0),
  //           Color.fromRGBO(0, 0, 0, 0.5),
  //           Colors.white,
  //           Colors.white
  //         ],
  //         stops: [0.0, 0.01, 0.03, 0.05, 0.95, 0.97, 0.99, 1.0],
  //       ).createShader(rect);
  //     },
  //     blendMode: BlendMode.dstOut,
  //   );
  // }

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
          Container(
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
                  height: 20,
                ),
                Text(
                  "${MyDatabase.countFreeWines(context: context).toString()} bouteilles en vrac"
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: MyDatabase.getFreeWines(context: context)
                      .map((freeWines) {
                    Wine wine = freeWines["wine"] as Wine;
                    int freeQuantity = freeWines["freeQuantity"] as int;
                    Map<String, dynamic>? enhancedWine =
                        MyDatabase.getEnhancedWineById(
                            context: context, wineId: wine.id);
                    if (enhancedWine == null) return Container();

                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                        boxShadow: ShadowBox.shadow1(),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 5,
                              color: Colors.red,
                            ),
                            Expanded(
                              child: Material(
                                child: ListTile(
                                  onTap: () {},
                                  tileColor: Colors.white,
                                  title: Text(
                                    "château hennebelle".toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        enhancedWine["appellation"]["name"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        freeQuantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
                // Container(
                //   color: Colors.red,
                //   child: InkWell(
                //     child: Text("Go to"),
                //     // onTap: () => Navigator.pushNamed(context, "/second"),
                //     // onTap: () async {
                //     //   Wine wine = Wine(
                //     //     id: "2id",
                //     //     appellation: "appellation",
                //     //     createdAt: 2,
                //     //     editedAt: 2,
                //     //     enabled: true,
                //     //   );
                //     //   await DatabaseSelectors.addWine(context: context, wine: wine);
                //     // },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
