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
  String owner;

  // Custom
  String appellation;
  String domain;
  int quantity;
  int millesime;
  int size;
  bool bio;
  bool sparkling;
  int? tempmin;
  int? tempmax;
  int? yearmin;
  int? yearmax;

  Wine({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    required this.owner,
    this.enabled = false,
    required this.appellation,
    required this.domain,
    required this.quantity,
    required this.millesime,
    required this.size,
    this.bio = false,
    this.sparkling = false,
    this.tempmin,
    this.tempmax,
    this.yearmin,
    this.yearmax,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "bio");
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "sparkling");
    return _$WineFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$WineToJson(this);
    json = ModelMethods.boolToInt(json: json, property: "enabled");
    json = ModelMethods.boolToInt(json: json, property: "bio");
    json = ModelMethods.boolToInt(json: json, property: "sparkling");
    return json;
  }

  Map<String, dynamic> toJsonWithBool() {
    return _$WineToJson(this);
  }

  factory Wine.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$WineFromJson(data);
  }
}
