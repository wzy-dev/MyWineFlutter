class ModelMethods {
  static Map<String, dynamic> boolToInt(Map<String, dynamic> json) {
    json["enabled"] == true || json["enabled"] == 1
        ? json["enabled"] = 1
        : json["enabled"] = 0;
    return json;
  }

  static Map<String, dynamic> intToBool(Map<String, dynamic> json) {
    json["enabled"] == true || json["enabled"] == 1
        ? json["enabled"] = true
        : json["enabled"] = false;
    return json;
  }
}
