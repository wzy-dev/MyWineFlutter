import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../model_methods.dart';

part 'wine.g.dart';

@JsonSerializable()
class Wine {
  // Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;

  // Custom
  String appellation;
  int quantity;

  Wine(
      {required this.id,
      required this.createdAt,
      required this.editedAt,
      this.enabled = false,
      required this.appellation,
      required this.quantity});

  factory Wine.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(jsonCopy);
    return _$WineFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$WineToJson(this);
    return ModelMethods.boolToInt(json);
  }

  factory Wine.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$WineFromJson(data);
  }
}
