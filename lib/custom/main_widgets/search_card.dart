import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class SearchCard extends StatelessWidget {
  const SearchCard(
      {Key? key,
      required this.context,
      required this.wineId,
      required this.stopSearchAction})
      : super(key: key);

  final BuildContext context;
  final String wineId;
  final Function stopSearchAction;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? enhancedWine =
        MyDatabase.getEnhancedWineById(context: context, wineId: wineId);

    return ActionCard(
        enhancedWine: enhancedWine!,
        leftWidget:
            Icon(Icons.search_outlined, color: Theme.of(context).hintColor),
        listActions: [
          CustomElevatedButton(
            title: "Arrêter la recherche",
            icon: Icon(Icons.search_off_outlined),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            onPress: () => stopSearchAction(),
          ),
          CustomFlatButton(
            title: "Voir la fiche de ce vin",
            icon: Icon(Icons.info_outline),
            onPress: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                "/wine",
                arguments: WineDetailsArguments(wineId: wineId),
              );
            },
            backgroundColor: Theme.of(context).hintColor,
          )
        ]);
  }
}
