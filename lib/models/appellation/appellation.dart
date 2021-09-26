import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Appellation({
    required this.id,
    required this.createdAt,
    required this.editedAt,
    this.enabled = false,
    required this.color,
  });

  factory Appellation.fromJson(Map<String, dynamic> json) =>
      _$AppellationFromJson(json);

  Map<dynamic, dynamic> toJson() => _$AppellationToJson(this);

  factory Appellation.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    Appellation appellation = Appellation.fromJson(data);
    return appellation;
  }
}
