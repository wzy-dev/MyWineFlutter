import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddWineAppellationArguments {
  const AddWineAppellationArguments({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;
}

class AddWineAppellation extends StatelessWidget {
  const AddWineAppellation({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;

  @override
  Widget build(BuildContext context) {
    List<Appellation> _appellationsList = List<Appellation>.from(
        MyDatabase.getOnce(
            context: context,
            dataList:
                MyDatabase.getAppellations(context: context, listen: false)));

    return MainContainer(
      title: Text("Choisir une appellation"),
      child: FilterSearch(
        placeholder: "chercher une appellation...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        appellationsData: _appellationsList,
        addPath: addPath,
      ),
    );
  }
}
