import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'position.g.dart';

@JsonSerializable()
class Position {
  // Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;
  String owner;

  // Custom
  String block;
  String wine;
  int x;
  int y;

  Position({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    required this.owner,
    this.enabled = false,
    required this.block,
    required this.wine,
    required this.x,
    required this.y,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$PositionFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$PositionToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$PositionToJson(this);
  }

  factory Position.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$PositionFromJson(data);
  }

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}
