import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddWineAppellationArguments {
  const AddWineAppellationArguments({this.selectedRadio});

  final String? selectedRadio;
}

class AddWineAppellation extends StatelessWidget {
  const AddWineAppellation({this.selectedRadio});

  final String? selectedRadio;

  @override
  Widget build(BuildContext context) {
    List<Appellation> _appellationsList = List<Appellation>.from(
        MyDatabase.getOnce(
            context: context,
            dataList:
                MyDatabase.getAppellations(context: context, listen: false)));
    _appellationsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return MainContainer(
      title: Text("Choisir une appellation"),
      child: FilterSearch(
        placeholder: "chercher une appellation...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        appellationsData: _appellationsList,
      ),
    );
  }
}
