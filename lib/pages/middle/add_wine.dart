import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddWineArguments {
  AddWineArguments({this.appellations = const [], this.domain, this.millesime});

  final List<Appellation> appellations;
  final Domain? domain;
  final int? millesime;
}

class AddWine extends StatefulWidget {
  const AddWine({Key? key, this.resultSearchVision}) : super(key: key);

  final ResultSearchVision? resultSearchVision;

  @override
  _AddWineState createState() => _AddWineState();
}

class _AddWineState extends State<AddWine> {
  List<Appellation> _appellations = [];
  Appellation? _appellation;
  Domain? _domain;
  double _millesime = (DateTime.now().year - 1).roundToDouble();
  SizeBottle _size = SizeBottle(name: "Bouteille", value: 750);
  double _quantity = 6;
  MultiSliderArguments yearRange = MultiSliderArguments(min: null, max: null);
  MultiSliderArguments tempRange = MultiSliderArguments(min: null, max: null);
  bool _sparkling = false;
  bool _bio = false;

  @override
  void initState() {
    if (widget.resultSearchVision != null) {
      _appellations = widget.resultSearchVision!.appellations;
      _domain = widget.resultSearchVision!.domain;
      _millesime = widget.resultSearchVision!.millesime.roundToDouble();
    }
    super.initState();
  }

  _selectAppellation() async {
    String? selectedAppellation = await Navigator.of(context).pushNamed(
      "/add/wine/appellation",
      arguments: AddWineAppellationArguments(
          selectedRadio:
              _appellations.length > 0 ? _appellations[0].name : null),
    ) as String?;

    if (selectedAppellation == null) return;

    setState(() {
      _appellations =
          MyDatabase.getAppellations(context: context, listen: false)
              .where((element) => element.name == selectedAppellation)
              .toList();
      if (_appellations.length == 1) {
        setState(() {
          _appellation = _appellations[0];
          yearRange = MultiSliderArguments(
            min: _appellation!.yearmin,
            max: _appellation!.yearmax,
            minimumIsEnabled: _appellation!.yearmin == null ? false : true,
            maximumIsEnabled: _appellation!.yearmax == null ? false : true,
          );
          tempRange = MultiSliderArguments(
            min: _appellation!.tempmin,
            max: _appellation!.tempmax,
            minimumIsEnabled: _appellation!.tempmin == null ? false : true,
            maximumIsEnabled: _appellation!.tempmax == null ? false : true,
          );
        });
      }
    });
  }

  _selectDomain() async {
    String? selectedDomain = await Navigator.of(context).pushNamed(
      "/add/wine/domain",
      arguments: AddWineDomainArguments(
          selectedRadio: _domain != null ? _domain!.name : null),
    ) as String?;

    if (selectedDomain == null) return;

    setState(() {
      _domain = MyDatabase.getDomains(context: context, listen: false)
          .firstWhere((element) => element.name == selectedDomain);
    });
  }

  Future _drawSizesBottomSheet() {
    return showBarModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(children: [
            SizedBox(height: 30),
            ...CustomMethods.getSizes()
                .map((SizeBottle e) => Column(
                      children: [
                        Material(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.name,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  Text(
                                    "${(e.value / 1000)}L",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ))
                .toList(),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                value: 6,
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
                    key: UniqueKey(),
                    onChange: (MultiSliderArguments values) =>
                        yearRange = values,
                    suffix: (int value) => value > 1 ? "ans" : "an",
                    minPossible: 1,
                    minVal: yearRange.min ?? 2,
                    maxVal: yearRange.max ?? 5,
                    minimumIsEnabled: yearRange.minimumIsEnabled,
                    maximumIsEnabled: yearRange.maximumIsEnabled,
                  ),
                  SizedBox(height: 20),
                  Text("Température de service",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 5),
                  MultiSlider(
                    key: UniqueKey(),
                    onChange: (MultiSliderArguments values) =>
                        tempRange = values,
                    suffix: (int value) => "°C",
                    minPossible: 1,
                    minVal: tempRange.min ?? 12,
                    maxVal: tempRange.max ?? 15,
                    minimumIsEnabled: tempRange.minimumIsEnabled,
                    maximumIsEnabled: tempRange.maximumIsEnabled,
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
                  onPress: () {
                    MyActions.addWine(
                      context: context,
                      wine: Wine(
                        id: "yolo${DateTime.now().toUtc().millisecondsSinceEpoch.toInt()}",
                        editedAt: 1,
                        createdAt: 1,
                        enabled: true,
                        appellation: _appellation!.id,
                        domain: _domain!.id,
                        millesime: _millesime.round(),
                        quantity: _quantity.round(),
                        size: _size.value,
                        sparkling: _sparkling,
                        bio: _bio,
                        yearmin: yearRange.min,
                        yearmax: yearRange.max,
                        tempmin: yearRange.min,
                        tempmax: yearRange.max,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
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
          onTap: () => setState(() {
            yearRange = MultiSliderArguments(
              min: appellation.yearmin,
              max: appellation.yearmax,
              minimumIsEnabled: appellation.yearmin == null ? false : true,
              maximumIsEnabled: appellation.yearmax == null ? false : true,
            );
            tempRange = MultiSliderArguments(
              min: appellation.tempmin,
              max: appellation.tempmax,
              minimumIsEnabled: appellation.tempmin == null ? false : true,
              maximumIsEnabled: appellation.tempmax == null ? false : true,
            );
            _appellation = appellation;
          }),
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
