import 'package:flutter/material.dart';

class ShadowBox {
  static List<BoxShadow> shadow1() {
    return [BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 8)];
  }

  static BorderRadius borderRadiusAll({double radius = 20}) {
    return BorderRadius.all(Radius.circular(radius));
  }
}
