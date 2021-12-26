import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class RegionForm extends StatefulWidget {
  const RegionForm({
    Key? key,
    required this.submitAction,
    this.region,
  }) : super(key: key);

  final Function({
    required BuildContext context,
    required String name,
    required String country,
  }) submitAction;
  final Region? region;

  @override
  State<RegionForm> createState() => _RegionFormState();
}

class _RegionFormState extends State<RegionForm> {
  Country? _country;
  late String _name;

  String? _countryName;
  String? _countryId;

  @override
  void initState() {
    _name = widget.region?.name ?? "";
    _country = widget.region != null
        ? MyDatabase.getCountryById(
            context: context, countryId: widget.region!.country, listen: false)
        : null;
    _countryName = _country?.name ?? null;
    super.initState();
  }

  _selectCountry() async {
    String? selectedCountry = await Navigator.of(context).pushNamed(
      "/add/region/country",
      arguments: AddRegionCountryArguments(
        selectedRadio: _country != null ? _country!.name : null,
        addPath: "/add/country",
      ),
    ) as String?;

    setState(() {
      if (selectedCountry != null) _countryId = null;
      _countryName = selectedCountry;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_countryId != null) {
      _country =
          MyDatabase.getCountryById(context: context, countryId: _countryId!);
    } else if (_countryName != null) {
      _country = MyDatabase.getCountries(context: context)
          .firstWhereOrNull((country) => country.name == _countryName);

      _countryId = _country?.id;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MainContainer(
        title: Text("Ajouter une région"),
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
                            onPress: () => _selectCountry(),
                            title: "Pays",
                            choiceLabel: _country != null
                                ? _country!.name
                                : "Non défini".toUpperCase(),
                          ),
                        ),
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
                    country: _country!.id,
                    name: _name,
                  ),
                ),
              ),
            ],
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
    if (_name.length == 0) {
      errors.add("empty _name");
    }
    if (_country == null) {
      errors.add("empty _country");
    }
    if (errors.length > 0) return false;
    return true;
  }
}
