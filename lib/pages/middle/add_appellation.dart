import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddAppellation extends StatefulWidget {
  const AddAppellation({Key? key}) : super(key: key);

  @override
  State<AddAppellation> createState() => _AddAppellationState();
}

class _AddAppellationState extends State<AddAppellation> {
  MultiSliderArguments _yearRange = MultiSliderArguments(min: null, max: null);
  MultiSliderArguments _tempRange = MultiSliderArguments(min: null, max: null);
  Region? _region;
  String? _colorIndex;
  String _name = "";

  String? _regionName;

  _selectRegion() async {
    String? selectedRegion = await Navigator.of(context).pushNamed(
      "/add/appellation/region",
      arguments: AddAppellationRegionArguments(
        selectedRadio: _region != null ? _region!.name : null,
        addPath: "/add/region",
      ),
    ) as String?;

    setState(() {
      _regionName = selectedRegion;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_regionName != null) {
      _region = MyDatabase.getRegions(context: context)
          .firstWhereOrNull((region) => region.name == _regionName);
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
                      onChanged: (value) => setState(() => _name = value)),
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
                  onPress: () {
                    MyActions.addAppellation(
                      context: context,
                      appellation: Appellation(
                        id: "yolo${DateTime.now().toUtc().millisecondsSinceEpoch.toInt()}",
                        editedAt: 1636707748293,
                        createdAt: 1636707748293,
                        enabled: true,
                        name: _name,
                        region: _region!.id,
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
                    ).then((value) => Navigator.of(context).pop(_name));
                  },
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
