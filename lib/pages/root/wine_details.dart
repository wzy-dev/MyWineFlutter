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
      required IconData icon,
      required String label,
      required String value}) {
    return Expanded(
      child: Row(
        children: [
          Spacer(flex: 1),
          Flexible(
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 10),
                ),
                Text(
                  value,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            flex: 3,
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _drawStock(
      {required BuildContext context,
      required Map<String, dynamic> wine,
      int nbFreeWine = 0}) {
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
                  "${wine["quantity"].toString()} bouteilles en réserve",
                  style: Theme.of(context).textTheme.headline4,
                ),
                (nbFreeWine > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "dont ${nbFreeWine.toString()} en vrac${nbFreeWine > 1 ? "s" : ""}"
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawAging(
      {required BuildContext context, required Map<String, dynamic> wine}) {
    int? yearmin = wine["appellation"]["yearmin"];
    int? yearmax = wine["appellation"]["yearmax"];
    late String label;
    late String desc;
    late LinearGradient gradient;

    //Si aucune info
    if (yearmin == null && yearmax == null) return Container();

    int year = (DateTime.now().year - wine["millesime"]).toInt();

    if (yearmin == null || year >= yearmin) {
      if (yearmax == null || year <= yearmax) {
        label = "Prêt à boire";
      } else {
        label = "Peut-être trop âgé";
      }
    } else {
      label = "Peut-être trop jeune";
    }

    if (yearmin != null && yearmax != null) {
      gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(152, 189, 214, 1.0),
          Color.fromRGBO(152, 189, 214, 1.0),
          Color.fromRGBO(105, 219, 160, 1.0),
          Color.fromRGBO(105, 219, 160, 1.0),
          Color.fromRGBO(219, 101, 88, 1.0),
          Color.fromRGBO(219, 101, 88, 1.0)
        ],
        stops: [0, 0.1, 0.5, 0.6, 0.9, 1],
      );
      desc =
          "Potentiel de garde entre ${yearmin.toString()} et ${yearmax.toString()} ${yearmax == 1 ? "an" : "ans"}";
    } else if (yearmin != null) {
      gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(152, 189, 214, 1.0),
          Color.fromRGBO(152, 189, 214, 1.0),
          Color.fromRGBO(105, 219, 160, 1.0)
        ],
        stops: [0, 0.1, 0.5],
      );
      desc = "Boire après ${yearmin.toString()} ${yearmin == 1 ? "an" : "ans"}";
    } else if (yearmax != null) {
      gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(105, 219, 160, 1.0),
          Color.fromRGBO(219, 101, 88, 1.0),
          Color.fromRGBO(219, 101, 88, 1.0)
        ],
        stops: [0.6, 0.9, 1],
      );
      desc = "Boire après ${yearmax.toString()} ${yearmax == 1 ? "an" : "ans"}";
    }

    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headline4,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 0,
                          offset: Offset(0.4, 1),
                          blurRadius: 2)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(
                      -1.0 + _leftCursor(context: context, wine: wine) * 2, 0),
                  child: Container(
                    width: 10,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(200, 200, 200, 0.8),
                      border: Border.all(color: Colors.black45),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 0,
                            offset: Offset(0.4, 1),
                            blurRadius: 2)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 5),
                Text(desc),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _leftCursor(
      {required BuildContext context, required Map<String, dynamic> wine}) {
    double pourcent = 0;
    int millesime = wine["millesime"];
    int? yearmin = wine["yearmin"];
    int? yearmax = wine["yearmax"];

    if (yearmin != null && yearmax != null) {
      double moyen = (millesime + yearmin + millesime + yearmax).toDouble() / 2;
      double ecart = DateTime.now().year - moyen;
      double ecartT = (yearmax - yearmin) / 2;
      pourcent = ecart * (1 / 3 / 2 * 100) / ecartT + 50;
    } else if (yearmin != null) {
      double inf = (millesime + yearmin).toDouble();
      double ecart = DateTime.now().year - inf;
      double ecartT = (yearmin) / 2;
      pourcent = ecart * (1 / 3 / 2 * 100) / ecartT + (1 / 3 * 100);
    } else if (yearmax != null) {
      double sup = (millesime + yearmax).toDouble();
      double ecart = DateTime.now().year - sup;
      double ecartT = (yearmax) / 2;
      pourcent = ecart * (1 / 3 / 2 * 100) / ecartT + (2 / 3 * 100);
    }

    pourcent = pourcent / 100;
    if (pourcent < 0.1) pourcent = 0.1;
    if (pourcent > 0.9) pourcent = 0.9;
    return pourcent;
  }

  Widget _drawTemp(
      {required BuildContext context, required Map<String, dynamic> wine}) {
    int? tempmin = wine["appellation"]["tempmin"];
    int? tempmax = wine["appellation"]["tempmax"];

    if (tempmin == null && tempmax == null) return Container();

    return Container(
      width: double.infinity,
      child: CustomCard(
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thermostat_outlined,
              ),
              tempmin != null
                  ? tempmax != null
                      ? Text(
                          "Servir entre ${tempmin.toString()}°C et ${tempmax.toString()}°C")
                      : Text("Servir à plus de ${tempmin.toString()}°C")
                  : Text("Servir à moins de ${tempmax.toString()}°C"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as WineDetailsArguments;
    String wineId = args.wineId;
    Map<String, dynamic>? _wine =
        MyDatabase.getEnhancedWineById(context: context, wineId: wineId);
    int _nbFreeWine =
        MyDatabase.countFreeWineById(context: context, wineId: wineId);

    if (_wine == null) Navigator.of(context).pop();

    return MainContainer(
      title: "Détails du vin",
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
            height: 30,
            color: Colors.black,
          ),
          // Identité appellation
          CustomCard(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _wineInfoItem(
                        context: context,
                        icon: Icons.flag_outlined,
                        label: "Région",
                        value: _wine["appellation"]["region"]["name"],
                      ),
                      _wineInfoItem(
                        context: context,
                        icon: Icons.public_outlined,
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
                        icon: Icons.palette_outlined,
                        label: "Couleur",
                        value: CustomMethods.getColorLabelByIndex(
                            _wine["appellation"]["color"]),
                      ),
                      _wineInfoItem(
                        context: context,
                        icon: Icons.liquor_outlined,
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
                        icon: Icons.flare_outlined,
                        label: "Pétillant",
                        value: _wine["sparkling"] ? "Oui" : "Non",
                      ),
                      _wineInfoItem(
                        context: context,
                        icon: Icons.spa_outlined,
                        label: "Bio",
                        value: _wine["sparkling"] ? "Oui" : "Non",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Potentiel de garde
          _drawAging(context: context, wine: _wine),
          SizedBox(height: 20),
          // Affichage du stock
          Container(
            width: double.infinity,
            child: _drawStock(
                context: context, wine: _wine, nbFreeWine: _nbFreeWine),
          ),
          SizedBox(height: 20),
          // Affichage de la température
          _drawTemp(context: context, wine: _wine),
        ],
      ),
    );
  }
}
