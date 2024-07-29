// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigModelDevice _$AppConfigModelDeviceFromJson(
        Map<String, dynamic> json) =>
    AppConfigModelDevice(
      deviceId: json['device_id'] as String,
      deviceFp: json['device_fp'] as String,
      deviceName: json['device_name'] as String,
      model: json['model'] as String,
      seedId: json['seed_id'] as String,
      seedTime: json['seed_time'] as String,
    );

Map<String, dynamic> _$AppConfigModelDeviceToJson(
        AppConfigModelDevice instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'device_fp': instance.deviceFp,
      'device_name': instance.deviceName,
      'model': instance.model,
      'seed_id': instance.seedId,
      'seed_time': instance.seedTime,
    };
