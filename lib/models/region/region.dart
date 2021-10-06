import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'region.g.dart';

@JsonSerializable()
class Region {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;

  // Custom
  String name;
  String country;

  Region({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.name,
    required this.country,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$RegionFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$RegionToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$RegionToJson(this);
  }

  factory Region.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$RegionFromJson(data);
  }
}
