import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditAppellation extends StatelessWidget {
  const EditAppellation({Key? key, this.appellation}) : super(key: key);

  final Appellation? appellation;

  void _addAction({
    required BuildContext context,
    required String name,
    required String region,
    required String color,
    required int? yearmin,
    required int? yearmax,
    required int? tempmin,
    required int? tempmax,
  }) {
    Appellation appellation = InitializerModel.initAppellation(
      name: name,
      region: region,
      color: color,
      yearmin: yearmin,
      yearmax: yearmax,
      tempmin: tempmin,
      tempmax: tempmax,
    );
    appellation.enabled = true;
    MyActions.addAppellation(context: context, appellation: appellation)
        .then((value) => Navigator.of(context).pop(name));
  }

  void _editAction({
    required BuildContext context,
    required String name,
    required String region,
    required String color,
    required int? yearmin,
    required int? yearmax,
    required int? tempmin,
    required int? tempmax,
  }) {
    Appellation editedAppellation = appellation!;
    editedAppellation.name = name;
    editedAppellation.region = region;
    editedAppellation.color = color;
    editedAppellation.yearmin = yearmin;
    editedAppellation.yearmax = yearmax;
    editedAppellation.tempmin = tempmin;
    editedAppellation.tempmax = tempmax;

    MyActions.updateAppellation(
      context: context,
      appellation: appellation,
    ).then((value) => Navigator.of(context).pop(name));
  }

  @override
  Widget build(BuildContext context) {
    return AppellationForm(
      submitAction: appellation == null ? _addAction : _editAction,
      appellation: this.appellation,
    );
  }
}
