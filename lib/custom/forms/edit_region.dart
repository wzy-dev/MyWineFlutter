import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditRegion extends StatelessWidget {
  const EditRegion({Key? key, this.region}) : super(key: key);

  final Region? region;

  void _addAction({
    required BuildContext context,
    required String name,
    required String country,
  }) {
    Region region = InitializerModel.initRegion(
      name: name,
      country: country,
    );
    region.enabled = true;

    MyActions.addRegion(context: context, region: region)
        .then((value) => Navigator.of(context).pop(name));
  }

  void _editAction({
    required BuildContext context,
    required String name,
    required String country,
  }) {
    Region editedRegion = region!;
    editedRegion.name = name;
    editedRegion.country = country;

    MyActions.updateRegion(
      context: context,
      region: region,
    ).then((value) => Navigator.of(context).pop(name));
  }

  @override
  Widget build(BuildContext context) {
    return RegionForm(
      submitAction: region == null ? _addAction : _editAction,
      region: this.region,
    );
  }
}
