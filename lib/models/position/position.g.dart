// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      owner: json['owner'] as String,
      enabled: json['enabled'] as bool? ?? false,
      block: json['block'] as String,
      wine: json['wine'] as String,
      x: json['x'] as int,
      y: json['y'] as int,
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'owner': instance.owner,
      'block': instance.block,
      'wine': instance.wine,
      'x': instance.x,
      'y': instance.y,
    };
