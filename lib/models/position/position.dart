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

  // Custom
  String block;
  String wine;
  int x;
  int y;

  Position({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.block,
    required this.wine,
    required this.x,
    required this.y,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(jsonCopy);
    return _$PositionFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$PositionToJson(this);
    return ModelMethods.boolToInt(json);
  }

  factory Position.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$PositionFromJson(data);
  }
}
