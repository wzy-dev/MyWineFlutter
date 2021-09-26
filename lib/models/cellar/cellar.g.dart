// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cellar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cellar _$CellarFromJson(Map<String, dynamic> json) => Cellar(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      enabled: json['enabled'] as bool? ?? false,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CellarToJson(Cellar instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'name': instance.name,
    };
