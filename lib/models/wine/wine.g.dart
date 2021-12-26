// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wine _$WineFromJson(Map<String, dynamic> json) => Wine(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      owner: json['owner'] as String,
      enabled: json['enabled'] as bool? ?? false,
      appellation: json['appellation'] as String,
      domain: json['domain'] as String,
      quantity: json['quantity'] as int,
      millesime: json['millesime'] as int,
      size: json['size'] as int,
      bio: json['bio'] as bool? ?? false,
      sparkling: json['sparkling'] as bool? ?? false,
      tempmin: json['tempmin'] as int?,
      tempmax: json['tempmax'] as int?,
      yearmin: json['yearmin'] as int?,
      yearmax: json['yearmax'] as int?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$WineToJson(Wine instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'owner': instance.owner,
      'appellation': instance.appellation,
      'domain': instance.domain,
      'quantity': instance.quantity,
      'millesime': instance.millesime,
      'size': instance.size,
      'bio': instance.bio,
      'sparkling': instance.sparkling,
      'tempmin': instance.tempmin,
      'tempmax': instance.tempmax,
      'yearmin': instance.yearmin,
      'yearmax': instance.yearmax,
      'notes': instance.notes,
    };
