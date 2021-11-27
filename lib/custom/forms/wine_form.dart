import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WineForm extends StatefulWidget {
  const WineForm({
    Key? key,
    required this.submitAction,
    this.appellations = const [],
    this.domain,
    this.millesime,
    this.wine,
  }) : super(key: key);

  final Function({
    required BuildContext context,
    required String appellationId,
    required String domainId,
    required int millesime,
    required int quantity,
    required int size,
    required bool sparkling,
    required bool bio,
    int? yearmin,
    int? yearmax,
    int? tempmin,
    int? tempmax,
  }) submitAction;
  final List<Appellation> appellations;
  final Domain? domain;
  final int? millesime;
  final Wine? wine;

  @override
  _WineFormState createState() => _WineFormState();
}

class _WineFormState extends State<WineForm> {
  late List<Appellation> _appellations = [];
  late Appellation? _appellation;
  late Domain? _domain;
  late double _millesime;
  late SizeBottle _size = SizeBottle(name: "Bouteille", value: 750);
  late double _quantity;
  late MultiSliderArguments _yearRange =
      MultiSliderArguments(min: null, max: null);
  late MultiSliderArguments _tempRange =
      MultiSliderArguments(min: null, max: null);
  late bool _sparkling = false;
  late bool _bio = false;

  late String? _appellationName;
  late String? _domainName;

  @override
  void initState() {
    Map<String, dynamic>? enhancedWine = widget.wine != null
        ? MyDatabase.getEnhancedWineById(
            context: context, wineId: widget.wine!.id, listen: false)
        : null;

    _appellations = enhancedWine != null
        ? MyDatabase.getAppellations(context: context, listen: false)
            .where((appellation) =>
                appellation.name == enhancedWine["appellation"]["name"])
            .toList()
        : widget.appellations;

    _appellation = enhancedWine != null
        ? MyDatabase.getAppellationById(
            context: context, appellationId: enhancedWine["appellation"]["id"])
        : null;

    _domain = enhancedWine != null
        ? MyDatabase.getDomainById(
            context: context, domainId: enhancedWine["domain"].id)
        : widget.domain;

    _millesime = enhancedWine != null
        ? double.parse(enhancedWine["millesime"].toString())
        : widget.millesime?.roundToDouble() ??
            (DateTime.now().year - 1).roundToDouble();

    _size = CustomMethods.getSizes().firstWhere((SizeBottle size) =>
        size.value == (enhancedWine != null ? enhancedWine["size"] : 750));

    _quantity = enhancedWine != null
        ? double.parse(enhancedWine["quantity"].toString())
        : 6;

    _yearRange = MultiSliderArguments(
      min: enhancedWine?["yearmin"] ?? null,
      max: enhancedWine?["yearmax"] ?? null,
      minimumIsEnabled: enhancedWine != null && enhancedWine["yearmin"] != null,
      maximumIsEnabled: enhancedWine != null && enhancedWine["yearmax"] != null,
    );

    _tempRange = MultiSliderArguments(
      min: enhancedWine?["tempmin"] ?? null,
      max: enhancedWine?["tempmax"] ?? null,
      minimumIsEnabled: enhancedWine != null && enhancedWine["tempmin"] != null,
      maximumIsEnabled: enhancedWine != null && enhancedWine["tempmax"] != null,
    );

    _sparkling = enhancedWine?["sparkling"] ?? false;

    _bio = enhancedWine?["bio"] ?? false;

    _appellationName = enhancedWine?["appellation"]["name"] ?? null;
    _domainName = enhancedWine?["domain"].name ?? null;
    super.initState();
  }

  void _initSlider(Appellation appellation) {
    setState(() {
      _appellation = appellation;

      _yearRange = MultiSliderArguments(
        min: _appellation!.yearmin,
        max: _appellation!.yearmax,
        minimumIsEnabled: _appellation!.yearmin == null ? false : true,
        maximumIsEnabled: _appellation!.yearmax == null ? false : true,
      );
      _tempRange = MultiSliderArguments(
        min: _appellation!.tempmin,
        max: _appellation!.tempmax,
        minimumIsEnabled: _appellation!.tempmin == null ? false : true,
        maximumIsEnabled: _appellation!.tempmax == null ? false : true,
      );
    });
  }

  _selectAppellation() async {
    String? selectedAppellation = await Navigator.of(context).pushNamed(
      "/add/wine/appellation",
      arguments: AddWineAppellationArguments(
        selectedRadio: _appellations.length > 0 ? _appellations[0].name : null,
        addPath: "/add/appellation",
      ),
    ) as String?;

    if (selectedAppellation == null) return;

    setState(() {
      _appellation = null;
      _appellationName = selectedAppellation;
    });
  }

  _selectDomain() async {
    String? selectedDomain = await Navigator.of(context).pushNamed(
      "/add/wine/domain",
      arguments: AddWineDomainArguments(
        selectedRadio: _domain != null ? _domain!.name : null,
        addPath: "/add/domain",
      ),
    ) as String?;

    setState(() {
      _domainName = selectedDomain;
    });
  }

  Future _drawSizesBottomSheet() {
    int index = 0;
    return showCupertinoModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: Colors.white,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.8),
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(children: [
            SizedBox(height: 30),
            ...CustomMethods.getSizes().map((SizeBottle e) {
              index++;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _size = e;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: Icon(
                                      e.value == _size.value
                                          ? Icons.radio_button_checked_outlined
                                          : Icons
                                              .radio_button_unchecked_outlined,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  e.name,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ],
                            ),
                            Text(
                              "${(e.value / 1000)}L",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (index < CustomMethods.getSizes().length
                      ? Divider()
                      : SizedBox(
                          height: 20,
                        )),
                ],
              );
            }).toList(),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_domainName != null) {
      _domain = MyDatabase.getDomains(context: context)
          .firstWhereOrNull((element) => element.name == _domainName);
    }

    if (_appellationName != null) {
      _appellations = MyDatabase.getAppellations(context: context)
          .where((element) => element.name == _appellationName)
          .toList();

      if (_appellations.length == 1 &&
          (_appellation == null || _appellation!.id != _appellations[0].id)) {
        _initSlider(_appellations[0]);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: Text("Ajouter un vin"),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Material(
                          color: Colors.transparent,
                          child: _drawComplexChoice(
                            context: context,
                            onPress: () => _selectAppellation(),
                            title: "Appellation",
                            choiceLabel: _appellations.length > 0
                                ? _appellations[0].name
                                : "Non défini".toUpperCase(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          children: _appellations
                              .map((Appellation e) =>
                                  _drawCircleRadio(appellation: e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    child: _drawComplexChoice(
                      context: context,
                      onPress: () => _selectDomain(),
                      title: "Domaine",
                      choiceLabel:
                          _domain != null ? _domain!.name : "Non défini",
                    ),
                  ),
                  CustomCard(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Icon(Icons.query_builder_outlined),
                                ),
                                Text("Millésime"),
                              ],
                            )),
                            Expanded(
                              child: CupertinoSpinBox(
                                decoration: BoxDecoration(),
                                incrementIcon: Icon(
                                  Icons.add_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                decrementIcon: Icon(
                                  Icons.remove_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                min: 0,
                                max: (DateTime.now().year + 1).roundToDouble(),
                                value: _millesime,
                                textStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 17,
                                ),
                                onChanged: (value) => _millesime = value,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Icon(Icons.straighten_outlined),
                                ),
                                Text("Taille"),
                              ],
                            )),
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  child: Text(
                                    "${(_size.value / 1000)}L (${_size.name})",
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  onTap: () => _drawSizesBottomSheet(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Icon(Icons.add_shopping_cart_outlined),
                                ),
                                Text("Quantité"),
                              ],
                            )),
                            Expanded(
                              child: CupertinoSpinBox(
                                decoration: BoxDecoration(),
                                incrementIcon: Icon(
                                  Icons.add_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                decrementIcon: Icon(
                                  Icons.remove_circle_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                min: 1,
                                max: 99,
                                value: _quantity,
                                textStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 17,
                                ),
                                onChanged: (value) => _quantity = value,
                              ),
                            ),
                          ],
                        ),
                      ])),
                  Text("Temps de garde",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 5),
                  MultiSlider(
                    key: Key("${_appellation?.id ?? "unknow"}sliderYearRange"),
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
                    key: Key("${_appellation?.id ?? "unknow"}sliderTempRange"),
                    onChange: (MultiSliderArguments values) =>
                        _tempRange = values,
                    suffix: (int value) => "°C",
                    minPossible: 1,
                    minVal: _tempRange.min ?? 12,
                    maxVal: _tempRange.max ?? 15,
                    minimumIsEnabled: _tempRange.minimumIsEnabled,
                    maximumIsEnabled: _tempRange.maximumIsEnabled,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _drawCheckBox(
                        context: context,
                        label: "Pétillant".toUpperCase(),
                        onChange: () => setState(() {
                          _sparkling = !_sparkling;
                        }),
                        isSelected: _sparkling,
                      ),
                      SizedBox(width: 25),
                      _drawCheckBox(
                        context: context,
                        label: "Bio".toUpperCase(),
                        onChange: () => setState(() {
                          _bio = !_bio;
                        }),
                        isSelected: _bio,
                      ),
                    ],
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
                    appellationId: _appellation!.id,
                    domainId: _domain!.id,
                    millesime: _millesime.round(),
                    quantity: _quantity.round(),
                    size: _size.value,
                    sparkling: _sparkling,
                    bio: _bio,
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

  Widget _drawCheckBox(
      {required BuildContext context,
      required String label,
      required Function onChange,
      required bool isSelected}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Row(
          children: [
            Text(label, textAlign: TextAlign.end),
            Checkbox(
              value: isSelected,
              onChanged: (value) => onChange(),
              fillColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        onTap: () => onChange(),
      ),
    );
  }

  Widget _drawCircleRadio({required Appellation appellation}) {
    final double size = 32;
    final Map<String, dynamic> color =
        CustomMethods.getColorByIndex(appellation.color);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: color["color"],
        child: InkWell(
          onTap: _appellation != null && _appellation!.id == appellation.id
              ? null
              : () => _initSlider(appellation),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(),
            ),
            child: Center(
              child: _appellation != null && _appellation!.id == appellation.id
                  ? Icon(Icons.check_outlined, color: color["contrasted"])
                  : Container(),
            ),
          ),
        ),
      ),
    );
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
    if (_appellation == null) {
      errors.add("empty _appellation");
    }
    if (_domain == null) {
      errors.add("empty _domain");
    }
    if (errors.length > 0) return false;
    return true;
  }
}
