// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appellation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appellation _$AppellationFromJson(Map<String, dynamic> json) => Appellation(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      enabled: json['enabled'] as bool? ?? false,
      color: json['color'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$AppellationToJson(Appellation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'color': instance.color,
      'name': instance.name,
    };
