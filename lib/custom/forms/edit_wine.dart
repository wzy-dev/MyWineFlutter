import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditWine extends StatelessWidget {
  const EditWine({Key? key, required this.wine}) : super(key: key);

  final Wine wine;

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
    Wine editedWine = wine;
    editedWine.appellation = appellationId;
    editedWine.domain = domainId;
    editedWine.bio = bio;
    editedWine.millesime = millesime;
    editedWine.quantity = quantity;
    editedWine.size = size;
    editedWine.sparkling = sparkling;
    editedWine.tempmin = tempmin;
    editedWine.tempmax = tempmax;
    editedWine.yearmin = yearmin;
    editedWine.yearmax = yearmax;
    editedWine.notes = notes;

    MyActions.updateWine(
      context: context,
      wine: editedWine,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WineForm(
      submitAction: _submitAction,
      wine: wine,
    );
  }
}
