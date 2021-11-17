import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:mywine/shelf.dart';

class DetailsScaffold extends StatefulWidget {
  const DetailsScaffold({
    Key? key,
    required this.context,
    this.title,
    this.subtitle,
    this.subtitleLabel,
    required this.infoCardItems,
    this.yearmin,
    this.yearmax,
    this.tempmin,
    this.tempmax,
    required this.millesime,
    this.editMillesime,
    this.stockWidget,
  }) : super(key: key);

  final BuildContext context;
  final String? title;
  final String? subtitle;
  final String? subtitleLabel;
  final InfoCardItems infoCardItems;
  final int? yearmin;
  final int? yearmax;
  final int? tempmin;
  final int? tempmax;
  final int millesime;
  final Function(double)? editMillesime;
  final Widget? stockWidget;

  @override
  _DetailsScaffoldState createState() => _DetailsScaffoldState();
}

class _DetailsScaffoldState extends State<DetailsScaffold> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      children: [
        widget.title != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title!,
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(
                    height: 5,
                  )
                ],
              )
            : Container(),
        widget.subtitle != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.subtitle!,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(
                    width: 5,
                  ),
                  widget.subtitleLabel != null
                      ? Text(widget.subtitleLabel!,
                          style: Theme.of(context).textTheme.subtitle2)
                      : Text(""),
                ],
              )
            : Container(),
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
                    Details.wineInfoItem(
                      context: context,
                      icon: Icons.flag_outlined,
                      label: "Région",
                      value: widget.infoCardItems.region,
                    ),
                    Details.wineInfoItem(
                      context: context,
                      icon: Icons.public_outlined,
                      label: "Pays",
                      value: widget.infoCardItems.country,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Details.wineInfoItem(
                      context: context,
                      icon: Icons.palette_outlined,
                      label: "Couleur",
                      value: widget.infoCardItems.color,
                    ),
                    widget.infoCardItems.size != null
                        ? Details.wineInfoItem(
                            context: context,
                            icon: Icons.liquor_outlined,
                            label: "Taille",
                            value: widget.infoCardItems.size!,
                          )
                        : Expanded(child: Container()),
                  ],
                ),
                SizedBox(
                  height: (widget.infoCardItems.sparkling != null ||
                          widget.infoCardItems.bio != null
                      ? 15
                      : 0),
                ),
                Row(
                  children: [
                    widget.infoCardItems.sparkling != null
                        ? Details.wineInfoItem(
                            context: context,
                            icon: Icons.flare_outlined,
                            label: "Pétillant",
                            value: widget.infoCardItems.sparkling!,
                          )
                        : Expanded(child: Container()),
                    widget.infoCardItems.bio != null
                        ? Details.wineInfoItem(
                            context: context,
                            icon: Icons.spa_outlined,
                            label: "Bio",
                            value: widget.infoCardItems.bio!,
                          )
                        : Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Potentiel de garde
        Details.drawAging(
          context: context,
          millesime: widget.millesime,
          editMillesime: widget.editMillesime,
          yearmin: widget.yearmin,
          yearmax: widget.yearmax,
        ),
        SizedBox(height: 20),
        // Affichage du stock
        (widget.stockWidget != null ? widget.stockWidget! : Container()),
        // Affichage de la température
        Details.drawTemp(
          context: context,
          tempmin: widget.tempmin,
          tempmax: widget.tempmax,
        ),
      ],
    );
  }
}

class InfoCardItems {
  InfoCardItems(
      {required this.region,
      required this.country,
      required this.color,
      this.size,
      this.sparkling,
      this.bio});

  final String region;
  final String country;
  final String color;
  final String? size;
  final String? sparkling;
  final String? bio;
}

class Details {
  static Widget wineInfoItem(
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

  static Widget drawStock(
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
                onPress: () => Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                  "/cellar",
                  (_) => false,
                  arguments: CellarTabArguments(
                    searchedWine: MyDatabase.getWineById(
                      context: context,
                      listen: false,
                      wineId: wine["id"],
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
                      context: context, listen: false, wineId: wine["id"]);
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

  static Widget drawAging(
      {required BuildContext context,
      required int millesime,
      Function(double)? editMillesime,
      int? yearmin,
      int? yearmax}) {
    late String label;
    late String desc;
    late LinearGradient gradient;

    //Si aucune info
    if (yearmin == null && yearmax == null) return Container();

    int year = (DateTime.now().year - millesime).toInt();

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
      desc = "Boire avant ${yearmax.toString()} ${yearmax == 1 ? "an" : "ans"}";
    }

    return CustomCard(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: EdgeInsets.only(
          left: 2,
          right: 2,
          bottom: 20,
          top: editMillesime != null ? 0 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            editMillesime != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 180,
                      child: CupertinoSpinBox(
                        decoration: BoxDecoration(),
                        padding: const EdgeInsets.all(0),
                        incrementIcon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decrementIcon: Icon(
                          Icons.remove_circle_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        min: 0,
                        max: (DateTime.now().year + 1).roundToDouble(),
                        value: millesime.toDouble(),
                        textStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 17,
                        ),
                        onChanged: (value) => editMillesime(value),
                      ),
                    ),
                  )
                : Container(),
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
                      -1.0 +
                          leftCursor(
                                  context: context,
                                  millesime: millesime,
                                  yearmin: yearmin,
                                  yearmax: yearmax) *
                              2,
                      0),
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
            SizedBox(height: 5),
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

  static double leftCursor(
      {required BuildContext context,
      required int millesime,
      int? yearmin,
      int? yearmax}) {
    double pourcent = 0;

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
      pourcent = ecart * (1 / 3 / 2 * 100) / ecartT * 2 + (2 / 3 * 100);
    }

    pourcent = pourcent / 100;
    if (pourcent < 0.1) pourcent = 0.1;
    if (pourcent > 0.9) pourcent = 0.9;

    return pourcent;
  }

  static Widget drawTemp(
      {required BuildContext context, int? tempmin, int? tempmax}) {
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
}
