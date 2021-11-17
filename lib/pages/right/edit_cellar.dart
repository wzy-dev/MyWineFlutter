import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/shelf.dart';

class EditCellarArguments {
  EditCellarArguments({this.cellar});

  final Cellar? cellar;
}

class EditCellar extends StatefulWidget {
  const EditCellar({Key? key, this.cellar}) : super(key: key);

  final Cellar? cellar;

  @override
  _EditCellarState createState() => _EditCellarState();
}

class _EditCellarState extends State<EditCellar> {
  late String _name;
  late Cellar _cellar;

  @override
  void initState() {
    _name = widget.cellar?.name ?? "Ma nouvelle cave";
    _cellar = widget.cellar ??
        Cellar(
          createdAt: 0,
          editedAt: 0,
          id: "unknow",
          enabled: true,
          name: _name,
        );
    super.initState();
  }

  Widget _drawCellar({required Cellar cellar}) {
    return Column(
      children: [
        ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DrawCellar(
              cellarId: cellar.id,
              editable: true,
              sizeCell: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voulez-vous vraiment supprimer cette cave'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Supprimer une cave est une action irréversible !'),
                Text(
                    'Tous les vins présents dans cette cave seront mis "en vrac".'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                if (widget.cellar != null) {
                  MyActions.deleteCellar(
                    context: context,
                    cellar: _cellar,
                  ).then(
                    (value) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil(
                        "/cellar",
                        (_) => false,
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text(_name),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: TextInputCard(
                  label: "Nom de la cave",
                  value: _name,
                  onChanged: (value) => _name = value),
            ),
            Card(
              margin: const EdgeInsets.all(0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: Colors.white,
              child: AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: _drawCellar(cellar: _cellar),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomElevatedButton(
                    title: "Valider les changements",
                    icon: Icon(Icons.save_outlined),
                    backgroundColor: Theme.of(context).hintColor,
                    onPress: () {
                      _cellar.name = _name;
                      return MyActions.addCellar(
                        context: context,
                        cellar: _cellar,
                      ).then((value) => Navigator.of(context).pop(_cellar));
                    },
                  ),
                  CustomFlatButton(
                    title: "Supprimer cette cave",
                    icon: Icon(Icons.delete_outline),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPress: () => _showMyDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
