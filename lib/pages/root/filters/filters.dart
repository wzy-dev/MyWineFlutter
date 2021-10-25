import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> _selectedAppellations = [];
  List<ColorBottle> _selectedColors = [];
  List<String> _selectedDomains = [];
  List<Region> _selectedRegions = [];
  List<SizeBottle> _selectedSizes = [];
  bool _regionIsExpanded = true;
  bool _colorIsExpanded = true;
  bool _sizeIsExpanded = true;
  late List<Map<String, dynamic>> _listWines;

  @override
  void initState() {
    _listWines = MyDatabase.getEnhancedWines(context: context)
        .where((wine) => wine["quantity"] > 0)
        .toList();
    super.initState();
  }

  List<Region> _setFilteredRegions() {
    List<Map<String, dynamic>> listWines = _getWineList("region");
    List<Region> filteredRegionsList = [];

    listWines.forEach((wine) {
      Region? region = MyDatabase.getRegionById(
          context: context, regionId: wine["appellation"]["region"]["id"]);

      if (region != null) {
        filteredRegionsList.add(region);
      }
    });

    if (filteredRegionsList.length > 0) {
      List toRemove = [];
      _selectedRegions.forEach((selectedRegion) {
        int index = filteredRegionsList.indexWhere(
            (filteredRegion) => filteredRegion.name == selectedRegion.name);
        if (index == -1) toRemove.add(selectedRegion);
      });
      _selectedRegions.removeWhere((element) => toRemove.contains(element));
      return filteredRegionsList;
    }

    if (filteredRegionsList.length == 0) return [];

    return MyDatabase.getUsedRegions(context: context, listen: false);
  }

  List<Appellation> _setFilteredAppellations() {
    List<Map<String, dynamic>> listWines = _getWineList("appellation");
    List<Appellation> filteredAppellationsList = [];

    listWines.forEach((wine) {
      Appellation? appellation = MyDatabase.getAppellationById(
          context: context, appellationId: wine["appellation"]["id"]);

      if (appellation != null) {
        filteredAppellationsList.add(appellation);
      }
    });

    if (filteredAppellationsList.length > 0) {
      List toRemove = [];
      _selectedAppellations.forEach((selectedAppellation) {
        int index = filteredAppellationsList.indexWhere((filteredAppellation) =>
            filteredAppellation.name == selectedAppellation);
        if (index == -1) toRemove.add(selectedAppellation);
      });
      _selectedAppellations
          .removeWhere((element) => toRemove.contains(element));
      return filteredAppellationsList;
    }

    if (filteredAppellationsList.length == 0) return [];
    return MyDatabase.getUsedAppellations(context: context, listen: false);
  }

  List<ColorBottle> _setFilteredColors() {
    List<Map<String, dynamic>> listWines = _getWineList("color");
    List<ColorBottle> filteredColorsList = [];

    if (listWines.indexWhere((wine) => wine["appellation"]["color"] == "r") >
        -1)
      filteredColorsList.add(ColorBottle(
          name: CustomMethods.getColorByIndex("r")["name"], value: "r"));
    if (listWines.indexWhere((wine) => wine["appellation"]["color"] == "w") >
        -1)
      filteredColorsList.add(ColorBottle(
          name: CustomMethods.getColorByIndex("w")["name"], value: "w"));
    if (listWines.indexWhere((wine) => wine["appellation"]["color"] == "p") >
        -1)
      filteredColorsList.add(ColorBottle(
          name: CustomMethods.getColorByIndex("p")["name"], value: "p"));
    print(listWines.where((wine) => wine["appellation"]["color"] == "p"));
    if (filteredColorsList.length > 0) {
      List toRemove = [];
      _selectedColors.forEach((selectedColor) {
        int index = filteredColorsList.indexWhere(
            (filteredColor) => filteredColor.name == selectedColor.name);
        if (index == -1) toRemove.add(selectedColor);
      });
      _selectedColors.removeWhere((element) => toRemove.contains(element));
      return filteredColorsList;
    }

    if (filteredColorsList.length == 0) return [];
    return MyDatabase.getUsedColors(context: context);
  }

  List<Domain> _setFilteredDomains() {
    List<Map<String, dynamic>> listWines = _getWineList("domain");
    List<Domain> filteredDomainsList = [];

    listWines.forEach((wine) {
      Domain? domain = wine["domain"];

      if (domain != null) {
        filteredDomainsList.add(domain);
      }
    });

    if (filteredDomainsList.length > 0) {
      List toRemove = [];
      _selectedDomains.forEach((selectedDomain) {
        int index = filteredDomainsList.indexWhere(
            (filteredDomain) => filteredDomain.name == selectedDomain);
        if (index == -1) toRemove.add(selectedDomain);
      });
      _selectedDomains.removeWhere((element) => toRemove.contains(element));
      return filteredDomainsList;
    }

    if (filteredDomainsList.length == 0) return [];
    return MyDatabase.getUsedDomains(context: context, listen: false);
  }

  List<SizeBottle> _setFilteredSizes() {
    List<Map<String, dynamic>> listWines = _getWineList("size");
    List<SizeBottle> filteredSizesList = [];

    if (listWines.indexWhere((wine) => wine["size"] == 750) > -1)
      filteredSizesList.add(SizeBottle(name: "Bouteille", value: 750));
    if (listWines.indexWhere((wine) => wine["size"] == 1500) > -1)
      filteredSizesList.add(SizeBottle(name: "Magnum", value: 1500));

    if (filteredSizesList.length > 0) {
      List toRemove = [];
      _selectedSizes.forEach((selectedSize) {
        int index = filteredSizesList.indexWhere(
            (filteredSize) => filteredSize.name == selectedSize.name);
        if (index == -1) toRemove.add(selectedSize);
      });
      _selectedSizes.removeWhere((element) => toRemove.contains(element));
      return filteredSizesList;
    }

    if (filteredSizesList.length == 0) return [];
    return [
      SizeBottle(name: "Bouteille", value: 750),
      SizeBottle(name: "Magnum", value: 1500),
    ];
  }

  List<Map<String, dynamic>> _getWineList(String className) {
    return _listWines
        .where((wine) =>
            (className == "region" ||
                (_selectedRegions.length == 0 ||
                    _selectedRegions.indexWhere((region) =>
                            wine["appellation"]["region"]["name"] ==
                            region.name) >
                        -1)) &&
            (className == "appellation" ||
                (_selectedAppellations.length == 0 ||
                    _selectedAppellations.indexWhere((appellation) =>
                            wine["appellation"]["name"] == appellation) >
                        -1)) &&
            (className == "color" ||
                (_selectedColors.length == 0 ||
                    _selectedColors.indexWhere((color) =>
                            wine["appellation"]["color"] == color.value) >
                        -1)) &&
            (className == "domain" ||
                (_selectedDomains.length == 0 ||
                    _selectedDomains.indexWhere((domain) => wine["domain"].name == domain) >
                        -1)) &&
            (className == "size" ||
                (_selectedSizes.length == 0 ||
                    _selectedSizes.indexWhere((size) => wine["size"] == size.value) > -1)))
        .toList();
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
            className: "region",
            onPress: () => setState(
              () {
                _regionIsExpanded = !_regionIsExpanded;
              },
            ),
            titleButton: "Chercher une région",
            data: MyDatabase.getOnce(
              context: context,
              dataList: _setFilteredRegions(),
            ),
            selectedData: _selectedRegions,
          ),
          // Filtre de l'appellation
          _drawComplexFilter(
            context: context,
            selectedList: _selectedAppellations,
            className: "appellation",
            titleButton: "Chercher une appellation",
            onOpenFilter: () async {
              List<String>? selectedAppellations =
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                      "/filter/appellation",
                      arguments: FilterAppellationArguments(
                          initialSelection: _selectedAppellations,
                          filteredAppellationsList:
                              _setFilteredAppellations())) as List<String>?;

              if (selectedAppellations == null) return;

              setState(() {
                _selectedAppellations = selectedAppellations;
              });
            },
            deleteAction: (int index) => setState(() {
              _selectedAppellations.removeAt(index);
            }),
            deleteAllAction: () => setState(() {
              _selectedAppellations = [];
            }),
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
            className: "color",
            titleButton: "Chercher une couleur",
            data: _setFilteredColors(),
            selectedData: _selectedColors,
          ),
          // Filtre du domaine
          _drawComplexFilter(
            context: context,
            selectedList: _selectedDomains,
            className: "appellation",
            titleButton: "Chercher un domaine",
            onOpenFilter: () async {
              List<String>? selectedDomains =
                  await Navigator.of(context, rootNavigator: true).pushNamed(
                          "/filter/domain",
                          arguments: FilterDomainArguments(
                              initialSelection: _selectedDomains,
                              filteredDomainsList: _setFilteredDomains()))
                      as List<String>?;

              if (selectedDomains == null) return;

              setState(() {
                _selectedDomains = selectedDomains;
              });
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
            className: "size",
            titleButton: "Chercher une contenance",
            data: _setFilteredSizes(),
            selectedData: _selectedSizes,
          ),
          // Appliquer les filtres
          CustomElevatedButton(
            title: "Appliquer",
            icon: Icon(Icons.save_alt_outlined),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            onPress: () => Navigator.of(context).pop({
              "regions": _selectedRegions.map((region) => region.name).toList(),
              "appellations": _selectedAppellations,
              "colors": _selectedColors.map((color) => color.value).toList(),
              "domains": _selectedDomains,
              "sizes":
                  _selectedSizes.map((size) => size.value.toString()).toList(),
            }),
          ),
        ],
      ),
    );
  }

  Column _drawChipFilter(
      {required BuildContext context,
      required bool isExpanded,
      required Function onPress,
      required String className,
      required String titleButton,
      required List<dynamic> data,
      required List<dynamic> selectedData}) {
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
                          .indexWhere((element) => element.name == e.name);

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
                                : selectedData.add(e);
                          });
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
    required String className,
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
        Wrap(
          spacing: 5,
          children: [
            selectedList.length >= 2
                ? DeleteChip(
                    label: "Tout supprimer",
                    deleteAction: () => deleteAllAction(),
                  )
                : Container(),
            ...selectedList.map((e) {
              int index = selectedList.indexWhere((element) => element == e);
              return DeleteChip(
                label: e,
                deleteAction: () => deleteAction(index),
              );
            }).toList()
          ],
        ),
      ],
    );
  }
}
