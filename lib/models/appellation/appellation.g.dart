// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appellation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appellation _$AppellationFromJson(Map<String, dynamic> json) => Appellation(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      owner: json['owner'] as String,
      enabled: json['enabled'] as bool? ?? false,
      color: json['color'] as String,
      name: json['name'] as String,
      region: json['region'] as String,
      label: json['label'] as String?,
      tempmin: json['tempmin'] as int?,
      tempmax: json['tempmax'] as int?,
      yearmin: json['yearmin'] as int?,
      yearmax: json['yearmax'] as int?,
    );

Map<String, dynamic> _$AppellationToJson(Appellation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'owner': instance.owner,
      'color': instance.color,
      'name': instance.name,
      'region': instance.region,
      'label': instance.label,
      'tempmin': instance.tempmin,
      'tempmax': instance.tempmax,
      'yearmin': instance.yearmin,
      'yearmax': instance.yearmax,
    };
