import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddWineDomainArguments {
  const AddWineDomainArguments({this.selectedRadio});

  final String? selectedRadio;
}

class AddWineDomain extends StatelessWidget {
  const AddWineDomain({this.selectedRadio});

  final String? selectedRadio;

  @override
  Widget build(BuildContext context) {
    List<Domain> _domainsList = List<Domain>.from(MyDatabase.getOnce(
        context: context,
        dataList: MyDatabase.getDomains(context: context, listen: false)));
    _domainsList
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return MainContainer(
      title: Text("Choisir un domaine"),
      child: FilterSearch(
        placeholder: "chercher un domaine...",
        multiple: false,
        submitLabel: "Choisir",
        initialSelection: selectedRadio != null ? [selectedRadio!] : [],
        domainsData: _domainsList,
      ),
    );
  }
}
