import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.value,
    this.mini = false,
    this.color,
    this.contrastedColor,
  }) : super(key: key);

  final int value;
  final bool mini;
  final Color? color;
  final Color? contrastedColor;

  @override
  Widget build(BuildContext context) {
    final String stringValue = value.toString();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: (!mini
            ? (color != null ? color : Theme.of(context).hintColor)
            : Colors.transparent),
        border: (!mini
            ? null
            : Border.all(
                color: color ?? Colors.white,
                width: 1.5,
              )),
      ),
      width: (stringValue.length > 1 ? null : (!mini ? 23 : 20)),
      height: (!mini ? 23 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: (stringValue.length > 1
                ? (mini
                    ? const EdgeInsets.fromLTRB(5, 0, 5, 0)
                    : const EdgeInsets.fromLTRB(8, 0, 8, 0))
                : const EdgeInsets.all(0)),
            child: Text(
              stringValue,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mini && color != null
                    ? color
                    : contrastedColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: (mini ? 11 : 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
