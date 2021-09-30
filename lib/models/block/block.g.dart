// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      enabled: json['enabled'] as bool? ?? false,
      cellar: json['cellar'] as String,
      horizontalAlignment: json['horizontalAlignment'] as String? ?? "center",
      verticalAlignment: json['verticalAlignment'] as String? ?? "center",
      nbColumn: json['nbColumn'] as int,
      nbLine: json['nbLine'] as int,
      x: json['x'] as int,
      y: json['y'] as int,
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'cellar': instance.cellar,
      'horizontalAlignment': instance.horizontalAlignment,
      'verticalAlignment': instance.verticalAlignment,
      'nbColumn': instance.nbColumn,
      'nbLine': instance.nbLine,
      'x': instance.x,
      'y': instance.y,
    };
