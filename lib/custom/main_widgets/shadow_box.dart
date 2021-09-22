import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  const ShadowBox({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: child,
    );
  }
}
