import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AppellationForm extends StatefulWidget {
  const AppellationForm({
    Key? key,
    required this.submitAction,
    this.appellation,
  }) : super(key: key);

  final Function({
    required BuildContext context,
    required String name,
    required String region,
    required String color,
    required int? yearmin,
    required int? yearmax,
    required int? tempmin,
    required int? tempmax,
  }) submitAction;
  final Appellation? appellation;

  @override
  State<AppellationForm> createState() => _AppellationFormState();
}

class _AppellationFormState extends State<AppellationForm> {
  Region? _region;
  String? _colorIndex;
  late MultiSliderArguments _yearRange;
  late MultiSliderArguments _tempRange;
  late String _name;

  String? _regionName;
  String? _regionId;

  @override
  void initState() {
    _name = widget.appellation?.name ?? "";
    _region = widget.appellation != null
        ? MyDatabase.getRegionById(
            context: context,
            regionId: widget.appellation!.region,
            listen: false)
        : null;
    _regionName = _region?.name ?? null;
    _colorIndex = widget.appellation?.color;
    _yearRange = MultiSliderArguments(
        min: widget.appellation?.yearmin,
        max: widget.appellation?.yearmax,
        minimumIsEnabled: widget.appellation?.yearmin != null,
        maximumIsEnabled: widget.appellation?.yearmax != null);
    _tempRange = MultiSliderArguments(
        min: widget.appellation?.tempmin,
        max: widget.appellation?.tempmax,
        minimumIsEnabled: widget.appellation?.tempmin != null,
        maximumIsEnabled: widget.appellation?.tempmax != null);
    super.initState();
  }

  _selectRegion() async {
    String? selectedRegion = await Navigator.of(context).pushNamed(
      "/add/appellation/region",
      arguments: AddAppellationRegionArguments(
        selectedRadio: _region != null ? _region!.name : null,
        addPath: "/add/region",
      ),
    ) as String?;

    setState(() {
      if (selectedRegion != null) _regionId = null;
      _regionName = selectedRegion ?? _regionName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_regionId != null) {
      _region =
          MyDatabase.getRegionById(context: context, regionId: _regionId!);
    } else if (_regionName != null) {
      _region = MyDatabase.getRegions(context: context)
          .firstWhereOrNull((region) => region.name == _regionName);

      _regionId = _region?.id;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: Text("Ajouter une appellation"),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  TextInputCard(
                    label: "Nom de l'appellation",
                    value: _name,
                    onChanged: (value) => setState(() => _name = value),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Material(
                          color: Colors.transparent,
                          child: _drawComplexChoice(
                            context: context,
                            onPress: () => _selectRegion(),
                            title: "Région",
                            choiceLabel: _region != null
                                ? _region!.name
                                : "Non défini".toUpperCase(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          children: _drawCirclesRadio(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Temps de garde",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 5),
                  MultiSlider(
                    onChange: (MultiSliderArguments values) =>
                        _yearRange = values,
                    suffix: (int value) => value > 1 ? "ans" : "an",
                    minPossible: 1,
                    minVal: _yearRange.min ?? 2,
                    maxVal: _yearRange.max ?? 5,
                    minimumIsEnabled: _yearRange.minimumIsEnabled,
                    maximumIsEnabled: _yearRange.maximumIsEnabled,
                  ),
                  SizedBox(height: 20),
                  Text("Température de service",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 5),
                  MultiSlider(
                    onChange: (MultiSliderArguments values) =>
                        _tempRange = values,
                    suffix: (int value) => "°C",
                    minPossible: 1,
                    minVal: _tempRange.min ?? 12,
                    maxVal: _tempRange.max ?? 15,
                    minimumIsEnabled: _tempRange.minimumIsEnabled,
                    maximumIsEnabled: _tempRange.maximumIsEnabled,
                  ),
                  SizedBox(height: 60),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: CustomElevatedButton(
                  icon: Icon(Icons.save_outlined),
                  title: "Ajouter",
                  disabled: !_isComplete(),
                  dense: true,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPress: () => widget.submitAction(
                    context: context,
                    region: _region!.id,
                    name: _name,
                    color: _colorIndex!,
                    yearmin:
                        _yearRange.minimumIsEnabled ? _yearRange.min : null,
                    yearmax:
                        _yearRange.maximumIsEnabled ? _yearRange.max : null,
                    tempmin:
                        _tempRange.minimumIsEnabled ? _tempRange.min : null,
                    tempmax:
                        _tempRange.maximumIsEnabled ? _tempRange.max : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _drawCirclesRadio() {
    final double size = 32;
    final List<Map<String, dynamic>> listColors = [
      CustomMethods.getColorByIndex("r"),
      CustomMethods.getColorByIndex("w"),
      CustomMethods.getColorByIndex("p"),
    ];

    return listColors
        .map(
          (color) => Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: color["color"],
              child: InkWell(
                onTap: _colorIndex == color["index"]
                    ? null
                    : () => setState(() {
                          _colorIndex = color["index"];
                        }),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: Center(
                    child: _colorIndex == color["index"]
                        ? Icon(Icons.check_outlined, color: color["contrasted"])
                        : Container(),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  InkWell _drawComplexChoice(
      {required BuildContext context,
      required onPress,
      required String title,
      required String choiceLabel}) {
    return InkWell(
      onTap: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 5),
          Text(
            choiceLabel,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  bool _isComplete() {
    List<String> errors = [];
    if (_name.length == 0) {
      errors.add("empty _name");
    }
    if (_region == null) {
      errors.add("empty _region");
    }
    if (_colorIndex == null) {
      errors.add("empty _colorIndex");
    }
    if (errors.length > 0) return false;
    return true;
  }
}
