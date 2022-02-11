import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    this.disabled = false,
    this.onPress,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final Widget icon;
  final bool disabled;
  final onPress;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress == null || disabled ? null : () => onPress!(),
      child: icon,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(0, 0)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(8),
        ),
        alignment: Alignment.centerLeft,
        backgroundColor: MaterialStateProperty.all<Color>(
          disabled
              ? Color.fromRGBO(208, 188, 188, 1)
              : backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    required this.icon,
    this.disabled = false,
    this.onPress,
    this.backgroundColor,
    this.textColor,
    this.dense = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget icon;
  final bool disabled;
  final Function? onPress;
  final Color? backgroundColor;
  final Color? textColor;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress == null || disabled ? null : () => onPress!(),
      icon: Padding(
        padding: dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.fromLTRB(5, 0, 8, 0),
        child: icon,
      ),
      label: Padding(
        padding:
            dense ? const EdgeInsets.all(0) : const EdgeInsets.only(left: 4),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(color: textColor),
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(8),
        ),
        alignment: Alignment.centerLeft,
        backgroundColor: MaterialStateProperty.all<Color>(
          disabled
              ? Color.fromRGBO(208, 188, 188, 1)
              : backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton({
    required this.title,
    this.onPress,
    required this.icon,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final Function? onPress;
  final Widget icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress == null ? null : () => onPress!(),
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: backgroundColor,
        ),
        height: 36,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
          child: icon,
        ),
      ),
      label: Text(
        title.toUpperCase(),
        style: TextStyle(color: Colors.black54),
      ),
      style: ButtonStyle(
        // minimumSize: MaterialStateProperty.all<Size>(Size(64, 36)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(0),
        ),
        alignment: Alignment.centerLeft,
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
