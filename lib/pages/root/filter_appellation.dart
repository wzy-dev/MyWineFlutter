import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class FilterAppellationArguments {
  const FilterAppellationArguments({
    this.initialSelection = const [],
    this.filteredAppellationsList,
  });

  final List<String> initialSelection;
  final List<Appellation>? filteredAppellationsList;
}

class FilterAppellation extends StatelessWidget {
  const FilterAppellation({required this.filterAppellationArguments});

  final FilterAppellationArguments filterAppellationArguments;

  @override
  Widget build(BuildContext context) {
    List<Appellation> _appellationsList = List<Appellation>.from(
        MyDatabase.getOnce(
            context: context,
            dataList:
                filterAppellationArguments.filteredAppellationsList != null
                    ? filterAppellationArguments.filteredAppellationsList!
                    : MyDatabase.getAppellationsWithStock(
                        context: context, listen: false)));

    return MainContainer(
      title: Text("Filtrer par l'appellation"),
      child: FilterSearch(
        placeholder: "chercher une appellation...",
        type: "appellation",
        initialSelection: filterAppellationArguments.initialSelection,
        appellationsData: _appellationsList,
      ),
    );
  }
}
