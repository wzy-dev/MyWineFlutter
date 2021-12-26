import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineDetailsArguments {
  WineDetailsArguments({required this.wineId, this.fullScreenDialog = true});

  final String wineId;
  final bool fullScreenDialog;
}

class WineDetails extends StatelessWidget {
  const WineDetails({Key? key, required this.wineDetails}) : super(key: key);

  final WineDetailsArguments wineDetails;

  Widget _drawStock({
    required BuildContext context,
    required String wineId,
    int quantity = 0,
    int nbFreeWine = 0,
  }) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 7),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$quantity bouteilles en réserve",
                  style: Theme.of(context).textTheme.headline4,
                ),
                (nbFreeWine > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "dont $nbFreeWine en vrac${nbFreeWine > 1 ? "s" : ""}"
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : SizedBox()),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              child: CustomElevatedButton(
                onPress: () => Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                  "/cellar",
                  (_) => false,
                  arguments: CellarTabArguments(
                    searchedWine: MyDatabase.getWineById(
                      context: context,
                      listen: false,
                      wineId: wineId,
                    ),
                  ),
                ),
                title: "Trouver mes bouteilles",
                backgroundColor: Color.fromRGBO(26, 143, 52, 1),
                icon: Icon(Icons.search),
              ),
            ),
            Container(
              width: double.infinity,
              child: CustomElevatedButton(
                title: "Ajouter une bouteilles",
                backgroundColor: Theme.of(context).hintColor,
                icon: Icon(Icons.add),
                onPress: () {
                  Wine? addedWine = MyDatabase.getWineById(
                    context: context,
                    listen: false,
                    wineId: wineId,
                  );
                  if (addedWine == null) return;

                  addedWine.quantity++;
                  MyActions.updateWine(context: context, wine: addedWine);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String wineId = wineDetails.wineId;
    Map<String, dynamic>? _wine =
        MyDatabase.getEnhancedWineById(context: context, wineId: wineId);
    int _nbFreeWine =
        MyDatabase.countFreeWineById(context: context, wineId: wineId);

    if (_wine == null) Navigator.of(context).pop();

    return MainContainer(
      title: Text("Détails du vin"),
      action: InkWell(
        onTap: () => Navigator.of(context).pushNamed("/edit/wine",
            arguments: MyDatabase.getWineById(
                context: context, wineId: wineId, listen: false)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.construction_outlined),
                SizedBox(width: 4),
                Text("Modifier",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      child: DetailsScaffold(
        context: context,
        title: "${_wine!["domain"].name.toUpperCase()} ${_wine["millesime"]}",
        subtitle: _wine["appellation"]["name"],
        subtitleLabel: _wine["appellation"]["label"] != null
            ? "(${_wine["appellation"]["label"]})"
            : null,
        infoCardItems: InfoCardItems(
          region: _wine["appellation"]["region"]["name"],
          country: _wine["appellation"]["region"]["country"].name,
          color: CustomMethods.getColorByIndex(
              _wine["appellation"]["color"])["name"],
          size: "${(_wine["size"] / 1000).toString()}L",
          sparkling: _wine["sparkling"] ? "Oui" : "Non",
          bio: _wine["bio"] ? "Oui" : "Non",
        ),
        yearmin: _wine["yearmin"] ?? _wine["appellation"]["yearmin"],
        yearmax: _wine["yearmax"] ?? _wine["appellation"]["yearmax"],
        tempmin: _wine["tempmin"] ?? _wine["appellation"]["tempmin"],
        tempmax: _wine["tempmax"] ?? _wine["appellation"]["tempmax"],
        millesime: _wine["millesime"],
        stockWidget: Column(
          children: [
            Container(
              width: double.infinity,
              child: _drawStock(
                  context: context,
                  wineId: wineId,
                  nbFreeWine: _nbFreeWine,
                  quantity: _wine["quantity"]),
            ),
            SizedBox(height: 20),
          ],
        ),
        notes: _wine["notes"],
      ),
    );
  }
}
