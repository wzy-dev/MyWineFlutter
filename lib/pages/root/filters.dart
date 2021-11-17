import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key, this.selectedFilters}) : super(key: key);

  final WineListArguments? selectedFilters;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late SortBottle _sortBy;
  late List<Country> _selectedCountries;
  late List<Region> _selectedRegions;
  late List<Appellation> _selectedAppellations;
  late List<ColorBottle> _selectedColors;
  late List<Domain> _selectedDomains;
  late List<SizeBottle> _selectedSizes;
  late List<AgeBottle> _selectedAges;
  late List<Map<String, dynamic>> _listWines;

  @override
  void initState() {
    _sortBy = widget.selectedFilters?.sortBy ??
        SortBottle(
            name: "Millésime",
            icon: Icons.north_east_outlined,
            value: "millesimeasc");
    _selectedCountries = widget.selectedFilters?.selectedCountries ?? [];
    _selectedRegions = widget.selectedFilters?.selectedRegions ?? [];
    _selectedAppellations = widget.selectedFilters?.selectedAppellations ?? [];
    _selectedColors = widget.selectedFilters?.selectedColors ?? [];
    _selectedDomains = widget.selectedFilters?.selectedDomains ?? [];
    _selectedSizes = widget.selectedFilters?.selectedSizes ?? [];
    _selectedAges = widget.selectedFilters?.selectedAges ?? [];
    _listWines = MyDatabase.getEnhancedWines(context: context, listen: false)
        .where((wine) => wine["quantity"] > 0)
        .toList();
    super.initState();
  }

  List<Country> _setFilteredCountries() {
    List<Map<String, dynamic>> listWines = _getWineList("country");
    List<Country> filteredCountriesList = [];

    listWines.forEach((wine) {
      Country? country = MyDatabase.getCountryById(
          context: context,
          countryId: wine["appellation"]["region"]["country"].id);

      if (country != null) {
        filteredCountriesList.add(country);
      }
    });

    if (filteredCountriesList.length > 0) {
      List toRemove = [];
      _selectedCountries.forEach((selectedCountry) {
        int index = filteredCountriesList.indexWhere(
            (filteredCountry) => filteredCountry.name == selectedCountry.name);
        if (index == -1) toRemove.add(selectedCountry);
      });
      _selectedCountries.removeWhere((element) => toRemove.contains(element));
      return filteredCountriesList;
    }

    if (filteredCountriesList.length == 0) return [];

    return MyDatabase.getCountriesWithStock(context: context, listen: false);
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

    return MyDatabase.getRegionsWithStock(context: context, listen: false);
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
            filteredAppellation.name == selectedAppellation.name);
        if (index == -1) toRemove.add(selectedAppellation);
      });

      _selectedAppellations
          .removeWhere((element) => toRemove.contains(element));
      return filteredAppellationsList;
    }

    if (filteredAppellationsList.length == 0) return [];
    return MyDatabase.getAppellationsWithStock(context: context, listen: false);
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
    return MyDatabase.getColorsWithStock(context: context);
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
            (filteredDomain) => filteredDomain.name == selectedDomain.name);
        if (index == -1) toRemove.add(selectedDomain);
      });
      _selectedDomains.removeWhere((element) => toRemove.contains(element));
      return filteredDomainsList;
    }

    if (filteredDomainsList.length == 0) return [];
    return MyDatabase.getDomainsWithStock(context: context, listen: false);
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

  AgeBottle? _getAgeOfWine({required Map<String, dynamic> wine}) {
    int year = (DateTime.now().year - wine["millesime"]).toInt();

    if (wine["yearmin"] == null && wine["yearmax"] == null) return null;

    if (wine["yearmin"] == null || year >= wine["yearmin"]) {
      if (wine["yearmax"] == null || year <= wine["yearmax"]) {
        return AgeBottle(name: "Apogée", value: 1);
      } else {
        return AgeBottle(name: "Âgé", value: 2);
      }
    } else {
      return AgeBottle(name: "Jeune", value: 0);
    }
  }

  List<AgeBottle> _setFilteredAges() {
    List<Map<String, dynamic>> listWines = _getWineList("age");
    List<AgeBottle> filteredAgesList = [];

    if (listWines.indexWhere((wine) {
          AgeBottle? age = _getAgeOfWine(wine: wine);
          return age != null && age.value == 0;
        }) >
        -1) filteredAgesList.add(AgeBottle(name: "Jeune", value: 0));
    if (listWines.indexWhere((wine) {
          AgeBottle? age = _getAgeOfWine(wine: wine);
          return age != null && age.value == 1;
        }) >
        -1) filteredAgesList.add(AgeBottle(name: "Apogée", value: 1));
    if (listWines.indexWhere((wine) {
          AgeBottle? age = _getAgeOfWine(wine: wine);
          return age != null && age.value == 2;
        }) >
        -1) filteredAgesList.add(AgeBottle(name: "Âgé", value: 2));

    if (filteredAgesList.length > 0) {
      List toRemove = [];
      _selectedAges.forEach((selectedAge) {
        int index = filteredAgesList
            .indexWhere((filteredAge) => filteredAge.name == selectedAge.name);
        if (index == -1) toRemove.add(selectedAge);
      });
      _selectedSizes.removeWhere((element) => toRemove.contains(element));
      return filteredAgesList;
    }

    if (filteredAgesList.length == 0) return [];
    return [
      AgeBottle(name: "Apogée", value: 1),
      AgeBottle(name: "Âgé", value: 2),
      AgeBottle(name: "Jeun", value: 0),
    ];
  }

  List<Map<String, dynamic>> _getWineList(String className) {
    return _listWines
        .where((wine) =>
            (className == "country" ||
                (_selectedCountries.length == 0 ||
                    _selectedCountries.indexWhere((country) =>
                            wine["appellation"]["region"]["country"].name ==
                            country.name) >
                        -1)) &&
            (className == "region" ||
                (_selectedRegions.length == 0 ||
                    _selectedRegions.indexWhere((region) => wine["appellation"]["region"]["name"] == region.name) >
                        -1)) &&
            (className == "appellation" ||
                (_selectedAppellations.length == 0 ||
                    _selectedAppellations.indexWhere((appellation) =>
                            wine["appellation"]["name"] == appellation.name) >
                        -1)) &&
            (className == "color" ||
                (_selectedColors.length == 0 ||
                    _selectedColors.indexWhere((color) =>
                            wine["appellation"]["color"] == color.value) >
                        -1)) &&
            (className == "domain" ||
                (_selectedDomains.length == 0 ||
                    _selectedDomains.indexWhere((domain) => wine["domain"].name == domain.name) >
                        -1)) &&
            (className == "size" ||
                (_selectedSizes.length == 0 ||
                    _selectedSizes.indexWhere((size) => wine["size"] == size.value) >
                        -1)) &&
            (className == "age" ||
                (_selectedAges.length == 0 ||
                    _selectedAges.indexWhere((age) {
                          AgeBottle? ageBottle = _getAgeOfWine(wine: wine);
                          return ageBottle != null &&
                              ageBottle.value == age.value;
                        }) >
                        -1)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text("Filtrer mes vins"),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(0),
              children: [
                // Trier
                _drawRadioChipFilter(
                  context: context,
                  name: "Trier",
                  selectedData: _sortBy,
                  onPressed: (dynamic e) => setState(() {
                    _sortBy = e;
                  }),
                  data: [
                    SortBottle(
                        name: "Millésime",
                        icon: Icons.north_east_outlined,
                        value: "millesimeasc"),
                    SortBottle(
                        name: "Millésime",
                        icon: Icons.south_east_outlined,
                        value: "millesimedesc"),
                    SortBottle(name: "Appellation", value: "appellation"),
                    SortBottle(name: "Domaine", value: "domain"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de la région
                _drawChipFilter(
                  context: context,
                  name: "Pays",
                  data: MyDatabase.getOnce(
                    context: context,
                    dataList: _setFilteredCountries(),
                  ),
                  selectedData: _selectedCountries,
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de la région
                _drawChipFilter(
                  context: context,
                  name: "Région",
                  data: MyDatabase.getOnce(
                    context: context,
                    dataList: _setFilteredRegions(),
                  ),
                  selectedData: _selectedRegions,
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de l'appellation
                _drawComplexFilter(
                  context: context,
                  selectedList: _selectedAppellations,
                  refreshSelected: () => _setFilteredAppellations(),
                  name: "Appellation",
                  titleButton: "Chercher une appellation",
                  onOpenFilter: () async {
                    List<String>? selectedAppellations =
                        await Navigator.of(context, rootNavigator: true)
                                .pushNamed("/filter/appellation",
                                    arguments: FilterAppellationArguments(
                                        initialSelection: _selectedAppellations
                                            .map((e) => e.id)
                                            .toList(),
                                        filteredAppellationsList:
                                            _setFilteredAppellations()))
                            as List<String>?;

                    if (selectedAppellations == null) return;

                    setState(() {
                      _selectedAppellations = selectedAppellations
                          .map((id) => MyDatabase.getAppellationById(
                              context: context, appellationId: id)!)
                          .toList();
                    });
                  },
                  deleteAction: (int index) => setState(() {
                    _selectedAppellations.removeAt(index);
                  }),
                  deleteAllAction: () => setState(() {
                    _selectedAppellations = [];
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de la couleur
                _drawChipFilter(
                  context: context,
                  name: "Couleur",
                  data: _setFilteredColors(),
                  selectedData: _selectedColors,
                  colored: true,
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre du domaine
                _drawComplexFilter(
                  context: context,
                  selectedList: _selectedDomains,
                  refreshSelected: () => _setFilteredDomains(),
                  name: "Domaine",
                  titleButton: "Chercher un domaine",
                  onOpenFilter: () async {
                    List<String>? selectedDomains = await Navigator.of(context,
                                rootNavigator: true)
                            .pushNamed("/filter/domain",
                                arguments: FilterDomainArguments(
                                    initialSelection: _selectedDomains
                                        .map((e) => e.name)
                                        .toList(),
                                    filteredDomainsList: _setFilteredDomains()))
                        as List<String>?;

                    if (selectedDomains == null) return;

                    setState(() {
                      _selectedDomains = selectedDomains
                          .map((e) => MyDatabase.getDomainById(
                              context: context, domainId: e)!)
                          .toList();
                    });
                  },
                  deleteAction: (int index) => setState(() {
                    _selectedDomains.removeAt(index);
                  }),
                  deleteAllAction: () => setState(() {
                    _selectedDomains = [];
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de la contenance
                _drawChipFilter(
                  context: context,
                  name: "Contenance",
                  data: _setFilteredSizes(),
                  selectedData: _selectedSizes,
                ),
                SizedBox(
                  height: 10,
                ),
                // Filtre de l'âge
                _drawChipFilter(
                  context: context,
                  name: "Maturité",
                  data: _setFilteredAges(),
                  selectedData: _selectedAges,
                ),
                // Espacer pour le FAB
                SizedBox(
                  height: 80,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: CustomElevatedButton(
                icon: Icon(Icons.save_alt_outlined),
                title: "Appliquer",
                dense: true,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPress: () => Navigator.of(context).pop({
                  "sortby": _sortBy,
                  "countries": _selectedCountries,
                  "regions": _selectedRegions,
                  "appellations": _selectedAppellations,
                  "colors": _selectedColors,
                  "domains": _selectedDomains,
                  "sizes": _selectedSizes,
                  "ages": _selectedAges,
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawRadioChipFilter(
      {required BuildContext context,
      required String name,
      required List<dynamic> data,
      required dynamic selectedData,
      required Function onPressed,
      bool colored = false}) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              name,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            height: 40,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 5),
                  itemBuilder: (BuildContext context, int i) {
                    dynamic e = data[i];

                    return Row(
                      children: [
                        SizedBox(width: i == 0 ? 20 : 0),
                        InputChip(
                          label: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(colored ? e.name.toUpperCase() : e.name,
                                  style: TextStyle(color: null)),
                              e.icon != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Icon(e.icon, size: 12))
                                  : SizedBox(),
                            ],
                          ),
                          selected:
                              selectedData.value == e.value ? true : false,
                          pressElevation: 2,
                          padding: const EdgeInsets.all(5),
                          side: BorderSide(),
                          checkmarkColor: null,
                          backgroundColor: Colors.transparent,
                          selectedColor: Color.fromRGBO(47, 111, 143, 0.18),
                          onPressed: () => onPressed(e),
                          tooltip: selectedData.value == e.value
                              ? "Supprimer"
                              : "Ajouter",
                        ),
                        SizedBox(width: i == data.length - 1 ? 20 : 0),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawChipFilter(
      {required BuildContext context,
      required String name,
      required List<dynamic> data,
      required List<dynamic> selectedData,
      bool colored = false}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline2,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Wrap(
                spacing: 5,
                children: data.map((e) {
                  int index = selectedData
                      .indexWhere((element) => element.name == e.name);
                  Map<String, dynamic>? coloredSchema =
                      colored ? CustomMethods.getColorByIndex(e.value) : null;

                  return InputChip(
                    label: Text(colored ? e.name.toUpperCase() : e.name,
                        style: TextStyle(
                            color:
                                colored ? coloredSchema!["contrasted"] : null)),
                    selected: index > -1 ? true : false,
                    pressElevation: 2,
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(),
                    checkmarkColor:
                        colored ? coloredSchema!["contrasted"] : null,
                    backgroundColor:
                        colored ? coloredSchema!["color"] : Colors.transparent,
                    selectedColor: colored
                        ? coloredSchema!["color"]
                        : Color.fromRGBO(47, 111, 143, 0.18),
                    onPressed: () {
                      setState(() {
                        index > -1
                            ? selectedData.removeAt(index)
                            : selectedData.add(e);
                      });
                    },
                    tooltip: index > -1 ? "Supprimer" : "Ajouter",
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawComplexFilter({
    required BuildContext context,
    required Function onOpenFilter,
    required List<dynamic> selectedList,
    required Function refreshSelected,
    required Function(int) deleteAction,
    required Function deleteAllAction,
    required String name,
    required String titleButton,
  }) {
    refreshSelected();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 10),
          CustomElevatedButton(
            backgroundColor: Theme.of(context).hintColor,
            icon: Icon(Icons.playlist_add_check_outlined),
            title: titleButton,
            onPress: onOpenFilter,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Wrap(
              spacing: 5,
              children: [
                selectedList.length >= 2
                    ? DeleteChip(
                        label: "Tout supprimer",
                        deleteAction: () => deleteAllAction(),
                      )
                    : Container(),
                ...selectedList.map((e) {
                  int index = selectedList
                      .indexWhere((element) => element.name == e.name);
                  return DeleteChip(
                    label: e.name,
                    color: Color.fromRGBO(47, 111, 143, 0.18),
                    deleteAction: () => deleteAction(index),
                  );
                }).toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
