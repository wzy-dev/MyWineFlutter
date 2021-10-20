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
  late final List<Domain> _domainsList;

  @override
  Widget build(BuildContext context) {
    final FilterDomainArguments args =
        ModalRoute.of(context)!.settings.arguments as FilterDomainArguments;

    _domainsList = List<Domain>.from(MyDatabase.getOnce(
        context: context,
        dataList: args.filteredDomainsList != null
            ? args.filteredDomainsList!
            : MyDatabase.getDomains(context: context, listen: false)));

    return MainContainer(
      title: "Filtrer par un domaine",
      child: FilterSearch(
        placeholder: "chercher un domaine...",
        initialSelection: args.initialSelection,
        domainsData: _domainsList,
      ),
    );
  }
}
