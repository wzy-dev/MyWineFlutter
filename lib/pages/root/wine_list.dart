import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineList extends StatelessWidget {
  const WineList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Mes vins",
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: MyDatabase.getEnhancedWines(context: context)
            .where((wine) => wine["quantity"] > 0)
            .map((wine) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: WineItem(enhancedWine: wine),
                ))
            .toList(),
      ),
    );
  }
}
