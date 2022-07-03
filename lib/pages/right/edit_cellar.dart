import 'package:flutter/material.dart';
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
  late final bool _isNew;

  @override
  void initState() {
    if (widget.cellar != null) {
      _name = widget.cellar!.name;
      _cellar = widget.cellar!;
      _isNew = false;
    } else {
      _name = "Ma nouvelle cave";
      _cellar = InitializerModel.initCellar(name: _name);
      _isNew = true;
    }
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
              hero: false,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _drawDeleteDialog(
      {required BuildContext context,
      required Function popAction,
      required List<Position> positions}) async {
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
              child: Text(
                'Supprimer',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (!_isNew) {
                  Future.wait(positions.map((position) =>
                      MyActions.deletePosition(
                          context: context, position: position))).then(
                    (value) => MyActions.deleteCellar(
                      context: context,
                      cellar: _cellar,
                    ).then(
                      (value) {
                        popAction();
                      },
                    ),
                  );
                } else {
                  popAction();
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
    List<Position> positions = _isNew
        ? []
        : MyDatabase.getPositionsByCellarId(
            context: context, cellarId: _cellar.id);

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
                  autofocus: false,
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
                      _cellar.enabled = true;

                      if (widget.cellar == null) {
                        MyActions.addCellar(
                          context: context,
                          cellar: _cellar,
                        ).then(
                            (value) => Navigator.of(context).pop(_cellar.id));
                      } else {
                        MyActions.editCellar(
                          context: context,
                          cellar: _cellar,
                        ).then(
                            (value) => Navigator.of(context).pop(_cellar.id));
                      }
                    },
                  ),
                  CustomFlatButton(
                    title: "Supprimer cette cave",
                    icon: Icon(Icons.delete_outline),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPress: () => _drawDeleteDialog(
                      context: context,
                      popAction: () => Navigator.of(context).pop(),
                      positions: positions,
                    ),
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
