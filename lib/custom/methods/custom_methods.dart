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
}
