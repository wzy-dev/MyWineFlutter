import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model_methods.dart';

part 'domain.g.dart';

@JsonSerializable()
class Domain {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;

  // Custom
  String name;

  Domain({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.name,
  });

  factory Domain.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonCopy = Map.of(json);
    jsonCopy = ModelMethods.intToBool(json: jsonCopy, property: "enabled");
    return _$DomainFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _$DomainToJson(this);
    return ModelMethods.boolToInt(json: json, property: "enabled");
  }

  factory Domain.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    return _$DomainFromJson(data);
  }
}
