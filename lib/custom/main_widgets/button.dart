import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    this.onPress,
    required this.icon,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final Function? onPress;
  final Icon icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPress == null ? null : () => onPress!(),
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 8, 0),
        child: icon,
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title.toUpperCase(),
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(8),
        ),
        alignment: Alignment.centerLeft,
        backgroundColor: MaterialStateProperty.all<Color>(
          backgroundColor ?? Theme.of(context).colorScheme.primaryVariant,
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
  final Icon icon;
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
