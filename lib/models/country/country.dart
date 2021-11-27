import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;
  String owner;

  // Custom
  String name;

  Country({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    required this.owner,
    this.enabled = false,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$CountryFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$CountryToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$CountryToJson(this);
  }

  factory Country.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$CountryFromJson(data);
  }
}
