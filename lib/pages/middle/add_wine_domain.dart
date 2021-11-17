import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddWineDomainArguments {
  const AddWineDomainArguments({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;
}

class AddWineDomain extends StatelessWidget {
  const AddWineDomain({this.selectedRadio, this.addPath});

  final String? selectedRadio;
  final String? addPath;

  @override
  Widget build(BuildContext context) {
    List<Domain> _domainsList = List<Domain>.from(MyDatabase.getOnce(
        context: context,
        dataList: MyDatabase.getDomains(context: context, listen: false)));

    return MainContainer(
      title: Text("Choisir un domaine"),
      child: FilterSearch(
        placeholder: "chercher un domaine...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        domainsData: _domainsList,
        addPath: addPath,
      ),
    );
  }
}
