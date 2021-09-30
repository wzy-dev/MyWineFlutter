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

  // Custom
  String color;
  String name;

  Appellation({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.color,
    required this.name,
  });

  factory Appellation.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(jsonCopy);
    return _$AppellationFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$AppellationToJson(this);
    return ModelMethods.boolToInt(json);
  }

  factory Appellation.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$AppellationFromJson(data);
  }
}
