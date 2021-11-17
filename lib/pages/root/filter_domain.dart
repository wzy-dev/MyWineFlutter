import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class FilterDomainArguments {
  const FilterDomainArguments({
    this.initialSelection = const [],
    this.filteredDomainsList,
  });

  final List<String> initialSelection;
  final List<Domain>? filteredDomainsList;
}

class FilterDomain extends StatelessWidget {
  const FilterDomain({required this.filterDomainArguments});

  final FilterDomainArguments filterDomainArguments;

  @override
  Widget build(BuildContext context) {
    List<Domain> _domainsList = List<Domain>.from(MyDatabase.getOnce(
        context: context,
        dataList: filterDomainArguments.filteredDomainsList != null
            ? filterDomainArguments.filteredDomainsList!
            : MyDatabase.getDomainsWithStock(context: context, listen: false)));

    return MainContainer(
      title: Text("Filtrer par un domaine"),
      child: FilterSearch(
        placeholder: "chercher un domaine...",
        initialSelection: filterDomainArguments.initialSelection,
        domainsData: _domainsList,
      ),
    );
  }
}
