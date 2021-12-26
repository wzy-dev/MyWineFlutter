import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AddWine extends StatelessWidget {
  const AddWine({Key? key, this.resultSearchVision}) : super(key: key);

  final ResultSearchVision? resultSearchVision;

  void _submitAction({
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
    String? notes,
  }) {
    Wine wine = InitializerModel.initWine(
      appellation: appellationId,
      domain: domainId,
      millesime: millesime,
      quantity: quantity,
      size: size,
      sparkling: sparkling,
      bio: bio,
      yearmin: yearmin,
      yearmax: yearmax,
      tempmin: tempmin,
      tempmax: tempmax,
      notes: notes,
    );
    wine.enabled = true;

    MyActions.addWine(
      context: context,
      wine: wine,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WineForm(
      submitAction: _submitAction,
      appellations: resultSearchVision?.appellations ?? [],
      domain: resultSearchVision?.domain ?? null,
      millesime: resultSearchVision?.millesime ?? (DateTime.now().year - 1),
    );
  }
}
