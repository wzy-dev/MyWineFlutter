import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mywine/shelf.dart';

class EditCellarArguments {
  EditCellarArguments({required this.cellar});

  final Cellar cellar;
}

class EditCellar extends StatefulWidget {
  const EditCellar({Key? key, required this.cellar}) : super(key: key);

  final Cellar cellar;

  @override
  _EditCellarState createState() => _EditCellarState();
}

class _EditCellarState extends State<EditCellar> {
  String? _name;

  @override
  void initState() {
    _name = widget.cellar.name;
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

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: Text(widget.cellar.name),
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
                  value: widget.cellar.name,
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
                child: _drawCellar(cellar: widget.cellar),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                // TODO Ajouter actions
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomElevatedButton(
                    title: "Valider les changements",
                    icon: Icon(Icons.save_outlined),
                    backgroundColor: Theme.of(context).hintColor,
                  ),
                  CustomFlatButton(
                    title: "Supprimer cette cave",
                    icon: Icon(Icons.delete_outline),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
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
