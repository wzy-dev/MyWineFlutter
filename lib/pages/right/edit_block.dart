import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';

class EditBlockArguments {
  EditBlockArguments({
    required this.cellarId,
    this.blockId,
    this.nbColumn,
    this.nbLine,
    this.horizontalAlignment,
    this.verticalAlignment,
  });

  final String cellarId;
  final String? blockId;
  final int? nbColumn;
  final int? nbLine;
  final String? horizontalAlignment;
  final String? verticalAlignment;
}

class EditBlock extends StatefulWidget {
  const EditBlock({
    Key? key,
    required this.cellarId,
    this.blockId,
    this.nbColumn,
    this.nbLine,
    this.horizontalAlignment,
    this.verticalAlignment,
  }) : super(key: key);

  final String cellarId;
  final String? blockId;
  final int? nbColumn;
  final int? nbLine;
  final String? horizontalAlignment;
  final String? verticalAlignment;

  @override
  State<EditBlock> createState() => _EditBlockState();
}

class _EditBlockState extends State<EditBlock> {
  final int _sizeCell = 40;
  late int _nbColumn;
  late int _nbLine;
  late String _horizontalAlignment;
  late String _verticalAlignment;

  @override
  void initState() {
    _nbColumn = widget.nbColumn ?? 3;
    _nbLine = widget.nbLine ?? 4;
    _horizontalAlignment = widget.horizontalAlignment ?? "center";
    _verticalAlignment = widget.horizontalAlignment ?? "center";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Position> positions = widget.blockId != null
        ? MyDatabase.getPositionsByBlockId(
            context: context, blockId: widget.blockId!)
        : [];
    final int _maxUsedColumn = CustomMethods.getExtremity(
            list: positions, propertyToCompare: "x")["max"] ??
        0;
    final int _maxUsedLine = CustomMethods.getExtremity(
            list: positions, propertyToCompare: "y")["max"] ??
        0;

    return MainContainer(
      title: Text(
          MyDatabase.getCellarById(context: context, cellarId: widget.cellarId)
                  ?.name ??
              "ras"),
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
              maxValue: 15,
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
              maxValue: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 40, right: 15, bottom: 22),
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
                    title: "Supprimer ce casier",
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
                      blockId: widget.blockId,
                      nbColumn: _nbColumn,
                      nbLine: _nbLine,
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
