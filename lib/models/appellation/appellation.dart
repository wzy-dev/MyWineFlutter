import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'appellation.g.dart';

@JsonSerializable()
class Appellation {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;
  String owner;

  // Custom
  String color;
  String name;
  String region;
  String? label;
  int? tempmin;
  int? tempmax;
  int? yearmin;
  int? yearmax;

  Appellation({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    required this.owner,
    this.enabled = false,
    required this.color,
    required this.name,
    required this.region,
    this.label,
    this.tempmin,
    this.tempmax,
    this.yearmin,
    this.yearmax,
  });

  factory Appellation.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$AppellationFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$AppellationToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$AppellationToJson(this);
  }

  factory Appellation.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$AppellationFromJson(data);
  }
}
