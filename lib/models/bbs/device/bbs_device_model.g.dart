// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsDeviceModelResp _$BbsDeviceModelRespFromJson(Map<String, dynamic> json) =>
    BbsDeviceModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsDeviceModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsDeviceModelRespToJson(BbsDeviceModelResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data,
    };

BbsDeviceModelData _$BbsDeviceModelDataFromJson(Map<String, dynamic> json) =>
    BbsDeviceModelData(
      deviceFp: json['device_fp'] as String,
      code: (json['code'] as num).toInt(),
      message: json['msg'] as String,
    );

Map<String, dynamic> _$BbsDeviceModelDataToJson(BbsDeviceModelData instance) =>
    <String, dynamic>{
      'device_fp': instance.deviceFp,
      'code': instance.code,
      'msg': instance.message,
    };
