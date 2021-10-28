import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:collection/collection.dart';

class DrawBlock extends StatefulWidget {
  const DrawBlock({
    Key? key,
    required this.blockId,
    required this.nbLine,
    required this.nbColumn,
    this.selectedCoor,
    this.onPress,
    this.searchedWine,
  }) : super(key: key);

  final String blockId;
  final int nbLine;
  final int nbColumn;
  final Map<String, int>? selectedCoor;
  final Function? onPress;
  final Wine? searchedWine;

  @override
  State<DrawBlock> createState() => _DrawBlockState();
}

class _DrawBlockState extends State<DrawBlock> {
  Map<String, int>? _focusCoor;

  Widget _drawCircle({
    required BuildContext context,
    required Map<String, int> coor,
    String? wineId,
  }) {
    Color _circleColor;
    String? _appellationColor;

    if (wineId != null)
      _appellationColor = MyDatabase.getEnhancedWineById(
              context: context, wineId: wineId)?["appellation"]["color"] ??
          null;

    _circleColor = CustomMethods.getColorByIndex(_appellationColor)["color"]!;

    bool isSelected = false;
    bool isFocus = false;

    widget.selectedCoor != null &&
            widget.selectedCoor!["x"] == coor["x"] &&
            widget.selectedCoor!["y"] == coor["y"] &&
            widget.onPress != null
        ? isSelected = true
        : isSelected = false;

    _focusCoor != null &&
            _focusCoor!["x"] == coor["x"] &&
            _focusCoor!["y"] == coor["y"] &&
            widget.onPress != null
        ? isFocus = true
        : isFocus = false;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTapDown: widget.onPress != null && wineId != null
            ? (down) {
                setState(() {
                  _focusCoor = coor;
                });
              }
            : null,
        onTapUp: widget.onPress != null && wineId != null
            ? (up) {
                setState(() {
                  _focusCoor = null;
                });
                return widget.onPress!({"id": wineId, "coor": coor});
              }
            : null,
        onTapCancel: widget.onPress != null && wineId != null
            ? () {
                setState(() {
                  _focusCoor = null;
                });
              }
            : null,
        child: AnimatedContainer(
          clipBehavior: Clip.hardEdge,
          height: double.infinity,
          width: double.infinity,
          duration: Duration(milliseconds: 400),
          decoration: BoxDecoration(
            border: Border.all(),
            shape: BoxShape.circle,
            color: isFocus
                ? Theme.of(context).hintColor
                : (isSelected ? Theme.of(context).primaryColor : _circleColor),
          ),
          child: Container(
            color: widget.searchedWine == null
                ? null
                : widget.searchedWine!.id == wineId
                    ? null
                    : Color.fromRGBO(0, 0, 0, 0.4),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: isSelected ? 1 : 0,
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    List<Position> positions = MyDatabase.getPositionsByBlockId(
        context: context, blockId: widget.blockId);

    for (var y = widget.nbLine; y >= 1; y--) {
      List<Widget> cells = [];

      for (var x = 1; x <= widget.nbColumn; x++) {
        Position? position = positions
            .firstWhereOrNull((position) => position.x == x && position.y == y);

        cells.add(
          Expanded(
            child: _drawCircle(
              context: context,
              coor: {"x": x, "y": y},
              wineId: position?.wine ?? null,
            ),
          ),
        );
      }

      rows.add(
        Expanded(
          child: Row(
            children: cells,
          ),
        ),
      );
    }

    return Column(
      children: rows,
    );
  }
}
