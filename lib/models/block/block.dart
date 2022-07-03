import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;
  String owner;

  // Custom
  String cellar;
  String? layout;
  String? horizontalAlignment;
  String? verticalAlignment;
  int nbColumn;
  int nbLine;
  int x;
  int y;

  Block({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    required this.owner,
    this.enabled = false,
    required this.cellar,
    this.layout = "center",
    this.horizontalAlignment = "center",
    this.verticalAlignment = "center",
    required this.nbColumn,
    required this.nbLine,
    required this.x,
    required this.y,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$BlockFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$BlockToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$BlockToJson(this);
  }

  factory Block.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$BlockFromJson(data);
  }

  Map<String, dynamic> _toMap() {
    return {
      'nbColumn': nbColumn,
      'nbLine': nbLine,
      'x': x,
      'y': y,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}
