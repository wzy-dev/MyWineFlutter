import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineList extends StatefulWidget {
  const WineList({Key? key}) : super(key: key);

  @override
  State<WineList> createState() => _WineListState();
}

class _WineListState extends State<WineList> {
  List<Appellation> selectedAppellationList = [];

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Mes vins",
      action: ElevatedButton(
        onPressed: () =>
            Navigator.of(context, rootNavigator: true).pushNamed("/filters"),
        child: Text(
          "Filtrer",
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: MyDatabase.getEnhancedWines(context: context)
            .where((wine) => wine["quantity"] > 0)
            .where((wine) {
              List<String> listIds = [];
              selectedAppellationList
                  .forEach((appellation) => listIds.add(appellation.id));
              return listIds.contains(wine["appellation"]["id"]);
            })
            .map((wine) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: WineItem(enhancedWine: wine),
                ))
            .toList(),
      ),
    );
  }
}
