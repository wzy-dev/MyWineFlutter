import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class SizeBottle {
  SizeBottle({required this.name});

  final String name;
}

class ColorBottle {
  ColorBottle({required this.name});

  final String name;
}

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> _selectedAppellations = [];
  List<String> _selectedDomains = [];
  List<String> _selectedRegions = [];
  List<String> _selectedSizes = [];
  List<String> _selectedColors = [];
  bool _regionIsExpanded = false;
  bool _sizeIsExpanded = false;
  bool _colorIsExpanded = false;
  List<Appellation>? _filteredAppellationsList;
  List<Domain>? _filteredDomainsList;
  late List<Map<String, dynamic>> _listWines;

  @override
  void initState() {
    _listWines = MyDatabase.getEnhancedWines(context: context);
    super.initState();
  }

  _getEquivalentInTwoLists(
      {required List<Map<String, dynamic>> firstList,
      required List<Map<String, dynamic>> lastList}) {
    if (firstList.length == 0) return lastList;
    if (lastList.length == 0) return firstList;

    List<Map<String, dynamic>> result = [];

    firstList.forEach((aElement) {
      Map<String, dynamic> wine = lastList.firstWhere(
          (bElement) => bElement["id"] == aElement["id"],
          orElse: () => {"id": null});
      if (wine["id"] != null) {
        result.add(wine);
      }
    });

    return result;
  }

  void _filter() {
    List<Map<String, dynamic>> filteredListWinesRegionAndAppellation = [];
    List<Map<String, dynamic>> filteredListWinesRegion = [];
    List<Map<String, dynamic>> filteredListWinesAppellation = [];
    List<Map<String, dynamic>> filteredListWinesDomain = [];

    // On récupere tous les vins de chaque filtres (region, appellation, domaine...)

    _selectedRegions.forEach((region) => _listWines
        .where((wine) => wine["appellation"]["region"]["name"] == region)
        .forEach((wine) => filteredListWinesRegion.add(wine)));

    _selectedAppellations.forEach((appellation) => _listWines
        .where((wine) => wine["appellation"]["name"] == appellation)
        .forEach((wine) => filteredListWinesAppellation.add(wine)));

    _selectedDomains.forEach((domain) => _listWines
        .where((wine) => wine["domain"].name == domain)
        .forEach((wine) => filteredListWinesDomain.add(wine)));

    // On récupere la liste des appellations en fonction des régions

    List<Appellation> filteredAppellationsList = [];

    filteredListWinesRegion.forEach((wine) {
      Appellation? appellation = MyDatabase.getAppellationById(
          context: context, appellationId: wine["appellation"]["id"]);

      if (appellation != null) {
        filteredAppellationsList.add(appellation);
      }
    });

    if (filteredAppellationsList.length > 0)
      _filteredAppellationsList = filteredAppellationsList;

    if (filteredAppellationsList.length == 0)
      _selectedRegions.length > 0
          ? _filteredAppellationsList = []
          : _filteredAppellationsList = null;

    // On récupere la liste des domaines en fonction des régions et des appellations

    filteredListWinesRegionAndAppellation = _getEquivalentInTwoLists(
        firstList: filteredListWinesRegion,
        lastList: filteredListWinesAppellation);

    List<Domain> filteredDomainsList = [];

    filteredListWinesRegionAndAppellation.forEach((wine) {
      Domain? domain = wine["domain"];

      if (domain != null) {
        filteredDomainsList.add(domain);
      }
    });

    if (filteredDomainsList.length > 0)
      _filteredDomainsList = filteredDomainsList;

    if (filteredDomainsList.length == 0)
      _selectedAppellations.length > 0
          ? _filteredDomainsList = []
          : _filteredDomainsList = null;
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Filtrer mes vins",
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Filtre de la région
          _drawChipFilter(
            context: context,
            isExpanded: _regionIsExpanded,
            onPress: () => setState(
              () {
                _regionIsExpanded = !_regionIsExpanded;
              },
            ),
            titleButton: "Chercher une région",
            data: MyDatabase.getOnce(
              context: context,
              dataList: MyDatabase.getRegions(context: context, listen: false),
            ),
            selectedData: _selectedRegions,
          ),
          // Filtre de l'appellation
          _drawComplexFilter(
            context: context,
            selectedList: _selectedAppellations,
            titleButton: "Chercher une appellation",
            onOpenFilter: () async {
              List<String>? selectedAppellations =
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                      "/filter/appellation",
                      arguments: FilterAppellationArguments(
                          initialSelection: _selectedAppellations,
                          filteredAppellationsList:
                              _filteredAppellationsList)) as List<String>?;

              if (selectedAppellations == null) return;

              setState(() {
                _selectedAppellations = selectedAppellations;
              });

              _filter();
            },
            deleteAction: (int index) => setState(() {
              _selectedAppellations.removeAt(index);
            }),
            deleteAllAction: () => setState(() {
              _selectedAppellations = [];
            }),
          ),
          // Filtre du domaine
          _drawComplexFilter(
            context: context,
            selectedList: _selectedDomains,
            titleButton: "Chercher un domaine",
            onOpenFilter: () async {
              List<String>? selectedDomains =
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                          "/filter/domain",
                          arguments: FilterDomainArguments(
                              initialSelection: _selectedDomains,
                              filteredDomainsList: _filteredDomainsList))
                      as List<String>?;

              if (selectedDomains == null) return;

              setState(() {
                _selectedDomains = selectedDomains;
              });

              _filter();
            },
            deleteAction: (int index) => setState(() {
              _selectedDomains.removeAt(index);
            }),
            deleteAllAction: () => setState(() {
              _selectedDomains = [];
            }),
          ),
          // Filtre de la contenance
          _drawChipFilter(
            context: context,
            isExpanded: _sizeIsExpanded,
            onPress: () => setState(
              () {
                _sizeIsExpanded = !_sizeIsExpanded;
              },
            ),
            titleButton: "Chercher une contenance",
            data: [
              SizeBottle(name: "Bouteille"),
              SizeBottle(name: "Magnum"),
            ],
            selectedData: _selectedSizes,
          ),
          // Filtre de la couleur
          _drawChipFilter(
            context: context,
            isExpanded: _colorIsExpanded,
            onPress: () => setState(
              () {
                _colorIsExpanded = !_colorIsExpanded;
              },
            ),
            titleButton: "Chercher une couleur",
            data: [
              ColorBottle(name: "Rouge"),
              ColorBottle(name: "Blanc"),
              ColorBottle(name: "Rosé"),
            ],
            selectedData: _selectedColors,
          ),
        ],
      ),
    );
  }

  Column _drawChipFilter(
      {required BuildContext context,
      required bool isExpanded,
      required Function onPress,
      required String titleButton,
      required List<dynamic> data,
      required List<String> selectedData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomElevatedButton(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(isExpanded
              ? Icons.keyboard_arrow_up_outlined
              : Icons.keyboard_arrow_down_outlined),
          title: titleButton,
          onPress: () => onPress(),
        ),
        Container(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: isExpanded
                ? Wrap(
                    spacing: 5,
                    children: data.map((e) {
                      int index = selectedData
                          .indexWhere((element) => element == e.name);

                      return InputChip(
                        label: Text(e.name),
                        selected: index > -1 ? true : false,
                        pressElevation: 2,
                        padding: const EdgeInsets.all(5),
                        side: BorderSide(),
                        backgroundColor: Colors.transparent,
                        selectedColor: Color.fromRGBO(47, 111, 143, 0.18),
                        onPressed: () {
                          setState(() {
                            index > -1
                                ? selectedData.removeAt(index)
                                : selectedData.add(e.name);
                          });
                          _filter();
                        },
                        tooltip: "Supprimer",
                      );
                    }).toList(),
                  )
                : Container(),
          ),
        ),
      ],
    );
  }

  Column _drawComplexFilter({
    required BuildContext context,
    required Function onOpenFilter,
    required List<String> selectedList,
    required Function(int) deleteAction,
    required Function deleteAllAction,
    required String titleButton,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomElevatedButton(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.keyboard_arrow_down),
          title: titleButton,
          onPress: onOpenFilter,
        ),
        Container(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(width: 5),
            itemCount: selectedList.length,
            itemBuilder: (BuildContext context, int index) {
              InputChip chip = _drawChip(
                label: selectedList[index],
                deleteAction: () {
                  deleteAction(index);
                  _filter();
                },
              );

              if (index == 0 && selectedList.length >= 2) {
                return Row(
                  children: [
                    _drawChip(
                      label: "Tout supprimer",
                      deleteAction: () {
                        deleteAllAction();
                        _filter();
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    chip
                  ],
                );
              }

              return chip;
            },
          ),
        ),
      ],
    );
  }

  InputChip _drawChip({required String label, required Function deleteAction}) {
    return InputChip(
      pressElevation: 2,
      padding: const EdgeInsets.all(5),
      side: BorderSide(),
      backgroundColor: Colors.transparent,
      label: Text(label),
      deleteIcon: Icon(
        Icons.clear_outlined,
        size: 20,
      ),
      onDeleted: () => deleteAction(),
      onPressed: () => deleteAction(),
      deleteButtonTooltipMessage: "Supprimer",
      tooltip: "Supprimer",
    );
  }
}
