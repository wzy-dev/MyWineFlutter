// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wine _$WineFromJson(Map<String, dynamic> json) => Wine(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      editedAt: json['editedAt'] as int,
      enabled: json['enabled'] as bool? ?? false,
      appellation: json['appellation'] as String,
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$WineToJson(Wine instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'editedAt': instance.editedAt,
      'enabled': instance.enabled,
      'appellation': instance.appellation,
      'quantity': instance.quantity,
    };