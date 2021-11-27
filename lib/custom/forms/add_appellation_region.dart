import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddAppellationRegionArguments {
  const AddAppellationRegionArguments({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;
}

class AddAppellationRegion extends StatelessWidget {
  const AddAppellationRegion({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;

  @override
  Widget build(BuildContext context) {
    List<Region> _regionsList = List<Region>.from(MyDatabase.getOnce(
        context: context,
        dataList: MyDatabase.getRegions(context: context, listen: false)));

    return MainContainer(
      title: Text("Choisir une region"),
      child: FilterSearch(
        placeholder: "chercher une region...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        regionsData: _regionsList,
        addPath: addPath,
      ),
    );
  }
}
