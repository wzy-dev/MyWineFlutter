import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class AppellationDetailsArguments {
  AppellationDetailsArguments(
      {required this.appellationId, this.fullScreenDialog = true});

  final String appellationId;
  final bool fullScreenDialog;
}

class AppellationDetails extends StatefulWidget {
  const AppellationDetails({Key? key, required this.appellationDetails})
      : super(key: key);

  final AppellationDetailsArguments appellationDetails;

  @override
  State<AppellationDetails> createState() => _AppellationDetailsState();
}

class _AppellationDetailsState extends State<AppellationDetails> {
  int _millesime = DateTime.now().year - 1;

  @override
  Widget build(BuildContext context) {
    String appellationId = widget.appellationDetails.appellationId;
    Map<String, dynamic>? _appellation = MyDatabase.getEnhancedAppellationById(
        context: context, appellationId: appellationId);

    if (_appellation == null) Navigator.of(context).pop();

    return MainContainer(
      title: Text("Détails de l'appellation"),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      child: DetailsScaffold(
        key: UniqueKey(),
        context: context,
        title:
            "${_appellation!["name"].toUpperCase()} ${_appellation["label"] != null ? "(" + _appellation["label"] + ")" : ""}",
        infoCardItems: InfoCardItems(
          region: _appellation["region"]["name"],
          country: _appellation["region"]["country"].name,
          color: CustomMethods.getColorByIndex(_appellation["color"])["name"],
        ),
        yearmin: _appellation["yearmin"],
        yearmax: _appellation["yearmax"],
        tempmin: _appellation["tempmin"],
        tempmax: _appellation["tempmax"],
        millesime: _millesime,
        editMillesime: (double value) => setState(() {
          _millesime = value.round();
        }),
      ),
    );
  }
}
