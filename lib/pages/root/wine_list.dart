import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class WineListArguments {
  const WineListArguments({
    this.selectedRegions,
    this.selectedAppellations,
    this.selectedColors,
    this.selectedDomains,
    this.selectedSizes,
  });

  final List<String>? selectedRegions;
  final List<String>? selectedAppellations;
  final List<String>? selectedColors;
  final List<String>? selectedDomains;
  final List<String>? selectedSizes;
}

class WineList extends StatefulWidget {
  const WineList({
    Key? key,
    this.selectedRegions,
    this.selectedAppellations,
    this.selectedColors,
    this.selectedDomains,
    this.selectedSizes,
  }) : super(key: key);

  final List<String>? selectedRegions;
  final List<String>? selectedAppellations;
  final List<String>? selectedColors;
  final List<String>? selectedDomains;
  final List<String>? selectedSizes;

  @override
  State<WineList> createState() => _WineListState();
}

class _WineListState extends State<WineList> {
  late List<String> _selectedRegions;
  late List<String> _selectedAppellations;
  late List<String> _selectedColors;
  late List<String> _selectedDomains;
  late List<String> _selectedSizes;

  @override
  void initState() {
    _selectedRegions = widget.selectedRegions ?? [];
    _selectedAppellations = widget.selectedAppellations ?? [];
    _selectedColors = widget.selectedColors ?? [];
    _selectedDomains = widget.selectedDomains ?? [];
    _selectedSizes = widget.selectedSizes ?? [];
    super.initState();
  }

  _goToFilters() async {
    Map<String, List<String>>? filters =
        await Navigator.of(context, rootNavigator: true).pushNamed("/filters")
            as Map<String, List<String>>?;
    if (filters == null) return;

    setState(() {
      _selectedRegions = filters["regions"]!;
      _selectedAppellations = filters["appellations"]!;
      _selectedColors = filters["colors"]!;
      _selectedDomains = filters["domains"]!;
      _selectedSizes = filters["sizes"]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Mes vins",
      action: InkWell(
        onTap: () => _goToFilters(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Filtrer",
              style: TextStyle(color: Colors.white),
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
              ..._selectedRegions.map((e) => DeleteChip(
                    label: e,
                    deleteAction: () => setState(() {
                      _selectedRegions.remove(e);
                    }),
                  )),
              ..._selectedAppellations.map((e) => DeleteChip(
                    label: e,
                    deleteAction: () => setState(() {
                      _selectedAppellations.remove(e);
                    }),
                  )),
              ..._selectedColors.map((e) => DeleteChip(
                    label: CustomMethods.getColorByIndex(e)["name"],
                    deleteAction: () => setState(() {
                      _selectedColors.remove(e);
                    }),
                  )),
              ..._selectedDomains.map((e) => DeleteChip(
                    label: e,
                    deleteAction: () => setState(() {
                      _selectedDomains.remove(e);
                    }),
                  )),
              ..._selectedSizes.map((e) => DeleteChip(
                    label: "${(double.parse(e) / 1000).toString()}L",
                    deleteAction: () => setState(() {
                      _selectedSizes.remove(e);
                    }),
                  )),
            ],
          ),
          ...MyDatabase.getEnhancedWines(context: context)
              .where((wine) => wine["quantity"] > 0)
              .where((wine) => _selectedRegions.length > 0
                  ? _selectedRegions
                      .contains(wine["appellation"]["region"]["name"])
                  : true)
              .where((wine) => _selectedAppellations.length > 0
                  ? _selectedAppellations.contains(wine["appellation"]["name"])
                  : true)
              .where((wine) => _selectedColors.length > 0
                  ? _selectedColors.contains(wine["appellation"]["color"])
                  : true)
              .where((wine) => _selectedDomains.length > 0
                  ? _selectedDomains.contains(wine["domain"].name)
                  : true)
              .where((wine) => _selectedSizes.length > 0
                  ? _selectedSizes.contains(wine["size"].toString())
                  : true)
              .map((wine) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: WineItem(enhancedWine: wine),
                  ))
              .toList()
        ],
      ),
    );
  }
}
