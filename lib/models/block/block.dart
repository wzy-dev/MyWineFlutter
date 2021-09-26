import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  //Main
  String id;
  int createdAt;
  int editedAt;
  bool? enabled;

  // Custom
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
    this.enabled = false,
    this.horizontalAlignment = "center",
    this.verticalAlignment = "center",
    required this.nbColumn,
    required this.nbLine,
    required this.x,
    required this.y,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<dynamic, dynamic> toJson() => _$BlockToJson(this);

  factory Block.fromFirestore(DocumentSnapshot documentSnapshot) {
    var data = documentSnapshot.data() as Map<String, dynamic>;

    data['id'] = documentSnapshot.reference.id;

    Block block = Block.fromJson(data);
    return block;
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
