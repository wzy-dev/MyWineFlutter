import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

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

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<dynamic, dynamic> toJson() => _$PositionToJson(this);

  factory Position.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    Position position = Position.fromJson(data);
    return position;
  }
}
