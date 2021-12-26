import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditCountry extends StatelessWidget {
  const EditCountry({Key? key, this.country}) : super(key: key);

  final Country? country;

  void _addAction({
    required BuildContext context,
    required String name,
  }) {
    Country country = InitializerModel.initCountry(
      name: name,
    );
    country.enabled = true;

    MyActions.addCountry(context: context, country: country)
        .then((value) => Navigator.of(context).pop(name));
  }

  void _editAction({
    required BuildContext context,
    required String name,
  }) {
    Country editedCountry = country!;
    editedCountry.name = name;

    MyActions.updateCountry(
      context: context,
      country: country,
    ).then((value) => Navigator.of(context).pop(name));
  }

  @override
  Widget build(BuildContext context) {
    return CountryForm(
      submitAction: country == null ? _addAction : _editAction,
      country: this.country,
    );
  }
}
