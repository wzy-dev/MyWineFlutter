import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../model_methods.dart';

part 'cellar.g.dart';

@JsonSerializable()
class Cellar {
  // Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;

  // Custom
  String name;

  Cellar({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.name,
  });

  factory Cellar.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(jsonCopy);
    return _$CellarFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$CellarToJson(this);
    return ModelMethods.boolToInt(json);
  }

  factory Cellar.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$CellarFromJson(data);
  }
}