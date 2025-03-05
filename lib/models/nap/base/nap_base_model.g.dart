// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapBaseModelPropertyFull _$NapBaseModelPropertyFullFromJson(
        Map<String, dynamic> json) =>
    NapBaseModelPropertyFull(
      propertyName: json['property_name'] as String,
      propertyId: (json['property_id'] as num).toInt(),
      base: json['base'] as String,
      level: (json['level'] as num).toInt(),
      valid: json['valid'] as bool,
      systemId: (json['system_id'] as num).toInt(),
      add: (json['add'] as num).toInt(),
    );

Map<String, dynamic> _$NapBaseModelPropertyFullToJson(
        NapBaseModelPropertyFull instance) =>
    <String, dynamic>{
      'property_name': instance.propertyName,
      'property_id': instance.propertyId,
      'base': instance.base,
      'level': instance.level,
      'valid': instance.valid,
      'system_id': instance.systemId,
      'add': instance.add,
    };

NapBaseModelProperty _$NapBaseModelPropertyFromJson(
        Map<String, dynamic> json) =>
    NapBaseModelProperty(
      propertyName: json['property_name'] as String,
      propertyId: (json['property_id'] as num).toInt(),
      base: json['base'] as String,
      add: json['add'] as String,
      finalProp: json['final'] as String,
    );

Map<String, dynamic> _$NapBaseModelPropertyToJson(
        NapBaseModelProperty instance) =>
    <String, dynamic>{
      'property_name': instance.propertyName,
      'property_id': instance.propertyId,
      'base': instance.base,
      'add': instance.add,
      'final': instance.finalProp,
    };
