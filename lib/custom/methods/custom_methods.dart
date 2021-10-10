import 'package:flutter/material.dart';

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

  static String getColorLabelByIndex(indexColor) {
    switch (indexColor) {
      case "r":
        return "Rouge";
      case "w":
        return "Blanc";
      case "p":
        return "Rosé";
      default:
        return "Inconnu";
    }
  }

  static Map<String, Color> getColorRgbaByIndex(indexColor) {
    switch (indexColor) {
      case "r":
        return {
          "color": Color.fromRGBO(219, 61, 77, 1),
          "contrasted": Colors.white70,
        };
      case "w":
        return {
          "color": Color.fromRGBO(248, 216, 114, 1),
          "contrasted": Colors.black54,
        };
      case "p":
        return {
          "color": Color.fromRGBO(255, 212, 196, 1),
          "contrasted": Colors.black54,
        };
      default:
        return {
          "color": Colors.white,
          "contrasted": Colors.black54,
        };
    }
  }
}
