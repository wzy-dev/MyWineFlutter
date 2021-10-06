class ModelMethods {
  static Map<String, dynamic> boolToInt(
      {required Map<String, dynamic> json, required String property}) {
    json[property] == true || json[property] == 1
        ? json[property] = 1
        : json[property] = 0;
    return json;
  }

  static Map<String, dynamic> intToBool(
      {required Map<String, dynamic> json, required String property}) {
    json[property] == true || json[property] == 1
        ? json[property] = true
        : json[property] = false;
    return json;
  }
}
