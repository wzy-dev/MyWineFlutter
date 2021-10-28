import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineItem extends StatelessWidget {
  const WineItem({
    Key? key,
    required this.enhancedWine,
    this.freeQuantity,
    this.expandable = false,
  }) : super(key: key);

  final Map<String, dynamic> enhancedWine;
  final int? freeQuantity;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    final Wine wine = MyDatabase.getWineById(
      context: context,
      wineId: enhancedWine["id"],
    )!;
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      color: Colors.white,
      child: Container(
        color: CustomMethods.getColorByIndex(
            enhancedWine["appellation"]["color"])["color"],
        child: Row(
          children: [
            Container(
              width: 10,
            ),
            expandable
                ? Expanded(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: _drawTitle(context),
                        subtitle: _drawSubTitle(context),
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        tilePadding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: CustomElevatedButton(
                              title: "Voir la fiche de ce vin",
                              icon: Icon(Icons.info_outline),
                              onPress: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  "/wine",
                                  arguments: WineDetailsArguments(
                                      wineId: enhancedWine["id"]),
                                );
                              },
                              backgroundColor: Theme.of(context).hintColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: CustomFlatButton(
                              title: "Trouver mes bouteilles",
                              icon: Icon(Icons.search_outlined),
                              onPress: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamedAndRemoveUntil(
                                "/cellar",
                                (_) => false,
                                arguments: CellarTabArguments(
                                  searchedWine: wine,
                                ),
                              ),
                              backgroundColor: Color.fromRGBO(26, 143, 52, 1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: CustomFlatButton(
                              title: "Boire cette bouteille",
                              icon: Icon(Icons.wine_bar_outlined),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPress: () => MyActions.drinkWine(
                                  context: context, wine: wine),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Material(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            "/wine",
                            arguments: WineDetailsArguments(
                              wineId: enhancedWine["id"],
                              fullScreenDialog: (expandable ? true : false),
                            ),
                          );
                        },
                        tileColor: Colors.white,
                        title: _drawTitle(context),
                        subtitle: _drawSubTitle(context),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Column _drawSubTitle(BuildContext context) {
    Map<String, dynamic> _colorScheme =
        CustomMethods.getColorByIndex(enhancedWine["appellation"]["color"]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3),
        Text(
          enhancedWine["appellation"]["name"],
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 7),
        Badge(
          value: freeQuantity ?? enhancedWine["quantity"],
          color: _colorScheme["color"],
          contrastedColor: _colorScheme["contrasted"],
        ),
      ],
    );
  }

  Text _drawTitle(BuildContext context) {
    return Text(
      "${enhancedWine["domain"].name.toUpperCase()} ${enhancedWine["millesime"]}",
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
