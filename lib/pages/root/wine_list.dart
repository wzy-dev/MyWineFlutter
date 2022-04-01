import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mywine/shelf.dart';

class WineListArguments {
  const WineListArguments({
    this.sortBy,
    this.selectedCountries,
    this.selectedRegions,
    this.selectedAppellations,
    this.selectedColors,
    this.selectedDomains,
    this.selectedSizes,
    this.selectedAges,
  });

  final SortBottle? sortBy;
  final List<Country>? selectedCountries;
  final List<Region>? selectedRegions;
  final List<Appellation>? selectedAppellations;
  final List<ColorBottle>? selectedColors;
  final List<Domain>? selectedDomains;
  final List<SizeBottle>? selectedSizes;
  final List<AgeBottle>? selectedAges;
}

class WineList extends StatefulWidget {
  const WineList({
    Key? key,
    this.selectedFilters,
  }) : super(key: key);

  final WineListArguments? selectedFilters;

  @override
  State<WineList> createState() => _WineListState();
}

class _WineListState extends State<WineList> {
  late SortBottle _sortBy;
  late List<Country> _selectedCountries;
  late List<Region> _selectedRegions;
  late List<Appellation> _selectedAppellations;
  late List<ColorBottle> _selectedColors;
  late List<Domain> _selectedDomains;
  late List<SizeBottle> _selectedSizes;
  late List<AgeBottle> _selectedAges;

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
    super.initState();
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

  void _goToFilters() async {
    Map<String, Object>? filters =
        await Navigator.of(context, rootNavigator: true).pushNamed("/filters",
            arguments: WineListArguments(
              sortBy: _sortBy,
              selectedCountries: _selectedCountries,
              selectedRegions: _selectedRegions,
              selectedAppellations: _selectedAppellations,
              selectedColors: _selectedColors,
              selectedDomains: _selectedDomains,
              selectedSizes: _selectedSizes,
              selectedAges: _selectedAges,
            )) as Map<String, Object>?;
    if (filters == null) return;

    setState(() {
      _sortBy = filters["sortby"]! as SortBottle;
      _selectedCountries = filters["countries"]! as List<Country>;
      _selectedRegions = filters["regions"]! as List<Region>;
      _selectedAppellations = filters["appellations"]! as List<Appellation>;
      _selectedColors = filters["colors"]! as List<ColorBottle>;
      _selectedDomains = filters["domains"]! as List<Domain>;
      _selectedSizes = filters["sizes"]! as List<SizeBottle>;
      _selectedAges = filters["ages"]! as List<AgeBottle>;
    });
  }

  List<Widget> _drawListWines() {
    List<Map<String, dynamic>> listWines = MyDatabase.getEnhancedWines(
            context: context)
        .where((wine) => wine["quantity"] > 0)
        .where((wine) => _selectedCountries.length > 0
            ? _selectedCountries.indexWhere((e) => e.name == wine["appellation"]["region"]["country"].name) >
                -1
            : true)
        .where((wine) => _selectedRegions.length > 0
            ? _selectedRegions.indexWhere(
                    (e) => e.name == wine["appellation"]["region"]["name"]) >
                -1
            : true)
        .where((wine) => _selectedAppellations.length > 0
            ? _selectedAppellations
                    .indexWhere((e) => e.name == wine["appellation"]["name"]) >
                -1
            : true)
        .where((wine) => _selectedColors.length > 0
            ? _selectedColors.indexWhere((e) => e.value == wine["appellation"]["color"]) > -1
            : true)
        .where((wine) => _selectedDomains.length > 0 ? _selectedDomains.indexWhere((e) => e.name == wine["domain"].name) > -1 : true)
        .where((wine) => _selectedSizes.length > 0 ? _selectedSizes.indexWhere((e) => e.value == wine["size"]) > -1 : true)
        .where((wine) => _selectedAges.length > 0
            ? _selectedAges.indexWhere((e) {
                  AgeBottle? age = _getAgeOfWine(wine: wine);
                  return age != null && age.value == e.value;
                }) >
                -1
            : true)
        .toList();

    switch (_sortBy.value) {
      case "millesimeasc":
        listWines.sort((a, b) => a["millesime"].compareTo(b["millesime"]));
        break;
      case "millesimedesc":
        listWines.sort((b, a) => a["millesime"].compareTo(b["millesime"]));
        break;
      case "appellation":
        listWines.sort((a, b) => a["appellation"]["name"]
            .toLowerCase()
            .compareTo(b["appellation"]["name"].toLowerCase()));
        break;
      case "domain":
        listWines.sort((a, b) => a["domain"]
            .name
            .toLowerCase()
            .compareTo(b["domain"].name.toLowerCase()));
        break;
    }

    if (listWines.length == 0)
      return [
        SvgPicture.asset(
          "assets/svg/wines_tasting.svg",
          width: MediaQuery.of(context).size.width,
        ),
        Text(
          "Vous n'avez pas de vins qui répondent à ces critères",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15),
        CustomElevatedButton(
          title: "Ajouter des bouteilles",
          icon: Icon(Icons.add_rounded),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPress: () => Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(
            "/add",
            (_) => false,
          ),
        ),
      ];

    return listWines
        .map((wine) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: WineItem(enhancedWine: wine),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text("Mes vins"),
      action: InkWell(
        onTap: () => _goToFilters(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.filter_alt_outlined),
                SizedBox(width: 4),
                Text(
                  "Trier/Filtrer",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Wrap(
            spacing: 5,
            children: [
              InputChip(
                pressElevation: 2,
                padding: const EdgeInsets.all(5),
                side: BorderSide(),
                backgroundColor: Colors.white,
                disabledColor: Colors.white,
                label: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Trier par : ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_sortBy.name),
                    _sortBy.icon != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Icon(_sortBy.icon, size: 10))
                        : SizedBox(),
                  ],
                ),
              ),
              ..._selectedCountries.map((Country e) => DeleteChip(
                    label: e.name,
                    deleteAction: () => setState(() {
                      _selectedCountries.remove(e);
                    }),
                  )),
              ..._selectedRegions.map((Region e) => DeleteChip(
                    label: e.name,
                    deleteAction: () => setState(() {
                      _selectedRegions.remove(e);
                    }),
                  )),
              ..._selectedAppellations.map((e) => DeleteChip(
                    label: e.name,
                    deleteAction: () => setState(() {
                      _selectedAppellations.remove(e);
                    }),
                  )),
              ..._selectedColors.map((ColorBottle e) {
                Map<String, dynamic> coloredSchema =
                    CustomMethods.getColorByIndex(e.value);
                return DeleteChip(
                  label: coloredSchema["name"].toUpperCase(),
                  color: coloredSchema["color"],
                  textColor: coloredSchema["contrasted"],
                  deleteAction: () => setState(() {
                    _selectedColors.remove(e);
                  }),
                );
              }),
              ..._selectedDomains.map((Domain e) => DeleteChip(
                    label: e.name,
                    deleteAction: () => setState(() {
                      _selectedDomains.remove(e);
                    }),
                  )),
              ..._selectedSizes.map((e) => DeleteChip(
                    label: "${(e.value / 1000).toString()}L",
                    deleteAction: () => setState(() {
                      _selectedSizes.remove(e);
                    }),
                  )),
              ..._selectedAges.map((e) => DeleteChip(
                    label: e.name,
                    deleteAction: () => setState(() {
                      _selectedAges.remove(e);
                    }),
                  )),
            ],
          ),
          (_selectedAppellations.length == 1
              ? CustomFlatButton(
                  title: "Vois les informations sur l'appellation",
                  icon: Icon(Icons.info_outline),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  onPress: () => Navigator.of(context).pushNamed(
                    "/appellation",
                    arguments: AppellationDetailsArguments(
                      appellationId: _selectedAppellations[0].id,
                      fullScreenDialog: false,
                    ),
                  ),
                )
              : Text("")),
          ..._drawListWines(),
        ],
      ),
    );
  }
}
