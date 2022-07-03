import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditBlockArguments {
  EditBlockArguments({
    required this.cellarId,
    required this.x,
    required this.y,
    this.block,
  });

  final String cellarId;
  final int x;
  final int y;
  final Block? block;
}

class EditBlock extends StatefulWidget {
  const EditBlock({
    Key? key,
    required this.cellarId,
    required this.x,
    required this.y,
    this.block,
  }) : super(key: key);

  final String cellarId;
  final int x;
  final int y;
  final Block? block;

  @override
  State<EditBlock> createState() => _EditBlockState();
}

class _EditBlockState extends State<EditBlock> {
  final int _sizeCell = 40;
  late final bool _isNew;
  late int _nbColumn;
  late int _nbLine;
  late String _layout;
  late String _horizontalAlignment;
  late String _verticalAlignment;
  late Block _block;

  @override
  void initState() {
    if (widget.block != null) {
      _isNew = false;
      _nbColumn = widget.block!.nbColumn;
      _nbLine = widget.block!.nbLine;
      _layout = widget.block!.layout ?? "center";
      _horizontalAlignment = widget.block!.horizontalAlignment ?? "center";
      _verticalAlignment = widget.block!.verticalAlignment ?? "center";
    } else {
      _isNew = true;
      _nbColumn = 4;
      _nbLine = 3;
      _layout = "center";
      _horizontalAlignment = "center";
      _verticalAlignment = "center";
    }

    _block = widget.block ??
        InitializerModel.initBlock(
          cellar: widget.cellarId,
          nbColumn: _nbColumn,
          nbLine: _nbLine,
          x: widget.x,
          y: widget.y,
          horizontalAlignment: _horizontalAlignment,
          verticalAlignment: _verticalAlignment,
        );
    super.initState();
  }

  Future<void> _drawDeleteDialog(
      {required BuildContext context,
      required Function popAction,
      required List<Position> positions}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voulez-vous vraiment supprimer ce casier'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Supprimer un casier est une action irréversible !'),
                Text(
                    'Tous les vins présents dans ce casier seront mis "en vrac".'),
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
                    (value) => MyActions.deleteBlock(
                      context: context,
                      block: _block,
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
        : MyDatabase.getPositionsByBlockId(
            context: context, blockId: _block.id);

    final int _maxUsedColumn = CustomMethods.getExtremity(
            list: positions, propertyToCompare: "x")["max"] ??
        0;
    final int _maxUsedLine = CustomMethods.getExtremity(
            list: positions, propertyToCompare: "y")["max"] ??
        0;

    return MainContainer(
      title: Text("Modifier un casier"),
      child: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          children: [
            _drawBlock(
              sizeCell: _sizeCell,
              context: context,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 22, right: 15, bottom: 22),
              child: Text("Disposition des rangées".toUpperCase(),
                  style: Theme.of(context).textTheme.headline1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    _drawAlignmentIcon(
                      selected: _layout == "start",
                      onPress: () => setState(() => _layout = "start"),
                      iconName: Icons.align_horizontal_left_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _layout == "center",
                      onPress: () => setState(() => _layout = "center"),
                      iconName: Icons.align_horizontal_center_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _layout == "end",
                      onPress: () => setState(() => _layout = "end"),
                      iconName: Icons.align_horizontal_right_outlined,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 22, right: 15, bottom: 22),
              child: Text("Alignement dans la cave".toUpperCase(),
                  style: Theme.of(context).textTheme.headline1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    _drawAlignmentIcon(
                      selected: _horizontalAlignment == "flex-start",
                      onPress: () =>
                          setState(() => _horizontalAlignment = "flex-start"),
                      iconName: Icons.format_align_left_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _horizontalAlignment == "center",
                      onPress: () =>
                          setState(() => _horizontalAlignment = "center"),
                      iconName: Icons.format_align_center_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _horizontalAlignment == "flex-end",
                      onPress: () =>
                          setState(() => _horizontalAlignment = "flex-end"),
                      iconName: Icons.format_align_right_outlined,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _drawAlignmentIcon(
                      selected: _verticalAlignment == "flex-start",
                      onPress: () =>
                          setState(() => _verticalAlignment = "flex-start"),
                      iconName: Icons.vertical_align_top_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _verticalAlignment == "center",
                      onPress: () =>
                          setState(() => _verticalAlignment = "center"),
                      iconName: Icons.vertical_align_center_outlined,
                    ),
                    SizedBox(width: 10),
                    _drawAlignmentIcon(
                      selected: _verticalAlignment == "flex-end",
                      onPress: () =>
                          setState(() => _verticalAlignment = "flex-end"),
                      iconName: Icons.vertical_align_bottom_outlined,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 40, right: 15, bottom: 22),
              child: Text(
                "Nombre de colonnes".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CustomNumberPicker(
              value: _nbColumn,
              onChange: (int index) => setState(() => _nbColumn = index),
              minValue: _maxUsedColumn > 0 ? _maxUsedColumn : 1,
              maxValue: 99,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 40, right: 15, bottom: 22),
              child: Text(
                "Nombre de lignes".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CustomNumberPicker(
              value: _nbLine,
              onChange: (int index) => setState(() => _nbLine = index),
              minValue: _maxUsedLine > 0 ? _maxUsedLine : 1,
              maxValue: 99,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 40, right: 15, bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomElevatedButton(
                    title: "Valider les changements",
                    icon: Icon(Icons.save_outlined),
                    backgroundColor: Theme.of(context).hintColor,
                    onPress: () {
                      _block.nbColumn = _nbColumn;
                      _block.nbLine = _nbLine;
                      _block.x = widget.x;
                      _block.y = widget.y;
                      _block.layout = _layout;
                      _block.horizontalAlignment = _horizontalAlignment;
                      _block.verticalAlignment = _verticalAlignment;
                      _block.enabled = true;

                      if (_isNew) {
                        MyActions.addBlock(
                          context: context,
                          block: _block,
                        ).then((value) => Navigator.of(context).pop());
                      } else {
                        MyActions.editBlock(
                          context: context,
                          block: _block,
                        ).then((value) => Navigator.of(context).pop());
                      }
                    },
                  ),
                  CustomFlatButton(
                    title: "Supprimer ce casier",
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

  Container _drawAlignmentIcon({
    required IconData iconName,
    required bool selected,
    required Function onPress,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 2,
          color:
              selected ? Theme.of(context).colorScheme.secondary : Colors.black,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPress(),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              iconName,
              color: selected ? Theme.of(context).colorScheme.secondary : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawBlock({
    required int sizeCell,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: Colors.white,
      child: AnimatedSize(
        duration: Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Container(
                    width: _nbColumn.toDouble() * sizeCell,
                    height: _nbLine.toDouble() * sizeCell,
                    child: DrawBlock(
                      blockId: _isNew ? null : widget.block!.id,
                      nbColumn: _nbColumn,
                      nbLine: _nbLine,
                      sizeCell: _sizeCell,
                      layout: _layout,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
