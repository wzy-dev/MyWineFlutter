import 'package:flutter/material.dart';
import 'package:mywine/models/bottle/size.dart';

class CustomMethods {
  static Map<String, int> getExtremity(
      {required List list, required String propertyToCompare}) {
    List sortedList = [...list];
    if (sortedList.length == 0)
      return {
        "min": 0,
        "max": 0,
      };

    if (sortedList.isNotEmpty) {
      sortedList.sort((a, b) =>
          a.get(propertyToCompare).compareTo(b.get(propertyToCompare)));
    }

    final Map<String, int> result = {
      "min": sortedList.first.get(propertyToCompare),
      "max": sortedList.last.get(propertyToCompare),
    };

    return result;
  }

  static double getAlignment(String? alignmentWord) {
    switch (alignmentWord) {
      case "flex-start":
        return -1;
      case "center":
        return 0;
      case "flex-end":
        return 1;
      default:
        return 0;
    }
  }

  static String getCatName(String cat) {
    switch (cat) {
      case "appellation":
        return "Appellation";
      case "domain":
        return "Domaine";
      case "country":
        return "Pays";
      case "region":
        return "Région";
      default:
        return "Unknow";
    }
  }

  static Map<String, dynamic> getColorByIndex(indexColor) {
    switch (indexColor) {
      case "r":
        return {
          "name": "Rouge",
          "color": Color.fromRGBO(219, 61, 77, 1),
          "contrasted": Colors.white70,
        };
      case "w":
        return {
          "name": "Blanc",
          "color": Color.fromRGBO(248, 216, 114, 1),
          "contrasted": Colors.black54,
        };
      case "p":
        return {
          "name": "Rosé",
          "color": Color.fromRGBO(255, 212, 196, 1),
          "contrasted": Colors.black54,
        };
      default:
        return {
          "name": "Inconnu",
          "color": Colors.white,
          "contrasted": Colors.black54,
        };
    }
  }

  static List<SizeBottle> getSizes() {
    return [
      SizeBottle(name: "Flacon", value: 100),
      SizeBottle(name: "Piccolo", value: 200),
      SizeBottle(name: "Chopine", value: 250),
      SizeBottle(name: "Demi-bouteille", value: 375),
      SizeBottle(name: "Pot", value: 500),
      SizeBottle(name: "Clavelin", value: 620),
      SizeBottle(name: "Bouteille", value: 750),
      SizeBottle(name: "Magnum", value: 1500),
      SizeBottle(name: "Marie-jeanne", value: 2250),
      SizeBottle(name: "Double Magnum", value: 3000),
      SizeBottle(name: "Réhoboam", value: 4500),
      SizeBottle(name: "Jéroboam", value: 5250),
      SizeBottle(name: "Impériale", value: 6000),
      SizeBottle(name: "Salmanazar", value: 9000),
      SizeBottle(name: "Balthazar", value: 12000),
      SizeBottle(name: "Nabuchodonosor", value: 15000),
      SizeBottle(name: "Melchior", value: 18000),
    ];
  }
}
