import 'package:flutter/material.dart';
import 'package:mywine/custom/scaffold/main_container.dart';
import 'package:mywine/shelf.dart';

class WineDetailsArguments {
  final String wineId;

  WineDetailsArguments(this.wineId);
}

class WineDetails extends StatelessWidget {
  const WineDetails({Key? key}) : super(key: key);

  Widget _wineInfoItem(
      {required BuildContext context,
      required Icon icon,
      required String label,
      required String value}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontSize: 10),
              ),
              Text(value),
            ],
          )
        ],
      ),
    );
  }

  String _getLabelColor(indexColor) {
    switch (indexColor) {
      case "r":
        return "Rouge";
      case "w":
        return "Blanc";
      case "p":
        return "Rosé";
      default:
        return "Inconnu";
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as WineDetailsArguments;
    String wineId = args.wineId;
    Map<String, dynamic>? _wine =
        MyDatabase.getEnhancedWineById(context: context, wineId: wineId);

    if (_wine == null) Navigator.of(context).pop();

    return MainContainer(
      title: "Détails du vin",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${_wine!["domain"].name.toUpperCase()} ${_wine["millesime"].toString()}",
                style: Theme.of(context).textTheme.headline4),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(_wine["appellation"]["name"],
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  width: 5,
                ),
                Text("(${_wine["appellation"]["label"]})",
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            CustomCard(
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.flag_outlined,
                          ),
                          label: "Région",
                          value: _wine["appellation"]["region"]["name"],
                        ),
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.public_outlined,
                          ),
                          label: "Pays",
                          value: _wine["appellation"]["region"]["country"].name,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.palette_outlined,
                          ),
                          label: "Couleur",
                          value: _getLabelColor(_wine["appellation"]["color"]),
                        ),
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.liquor_outlined,
                          ),
                          label: "Taille",
                          value: "${(_wine["size"] / 1000).toString()}L",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.flare_outlined,
                          ),
                          label: "Pétillant",
                          value: _wine["sparkling"] ? "Oui" : "Non",
                        ),
                        _wineInfoItem(
                          context: context,
                          icon: Icon(
                            Icons.spa_outlined,
                          ),
                          label: "Bio",
                          value: _wine["sparkling"] ? "Oui" : "Non",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: Row(
                children: [
                  Column(children: [Text("Info")]),
                  Column(children: [Text("appellation")]),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Row(
                children: [
                  Column(children: [Text("Info")]),
                  Column(children: [Text("stock")]),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Row(
                children: [
                  Column(children: [Text("Info")]),
                  Column(children: [Text("cépage")]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
