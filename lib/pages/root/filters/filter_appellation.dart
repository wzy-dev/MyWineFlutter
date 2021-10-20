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
  late final List<Appellation> _appellationsList;

  @override
  Widget build(BuildContext context) {
    final FilterAppellationArguments args = ModalRoute.of(context)!
        .settings
        .arguments as FilterAppellationArguments;

    _appellationsList = List<Appellation>.from(MyDatabase.getOnce(
        context: context,
        dataList: args.filteredAppellationsList != null
            ? args.filteredAppellationsList!
            : MyDatabase.getAppellations(context: context, listen: false)));
    return MainContainer(
      title: "Filtrer par l'appellation",
      child: FilterSearch(
        placeholder: "chercher une appellation...",
        initialSelection: args.initialSelection,
        appellationsData: _appellationsList,
      ),
    );
  }
}
