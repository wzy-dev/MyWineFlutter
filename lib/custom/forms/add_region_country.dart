import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddRegionCountryArguments {
  const AddRegionCountryArguments({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;
}

class AddRegionCountry extends StatelessWidget {
  const AddRegionCountry({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;

  @override
  Widget build(BuildContext context) {
    List<Country> _countrysList = List<Country>.from(MyDatabase.getOnce(
        context: context,
        dataList: MyDatabase.getCountries(context: context, listen: false)));

    return MainContainer(
      title: Text("Choisir un pays"),
      child: FilterSearch(
        placeholder: "chercher un pays...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        countriesData: _countrysList,
        addPath: addPath,
      ),
    );
  }
}
