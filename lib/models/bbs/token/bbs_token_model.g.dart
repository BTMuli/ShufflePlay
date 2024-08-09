// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsTokenModelLbSResp _$BbsTokenModelLbSRespFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelLbSResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsTokenModelLbSData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsTokenModelLbSRespToJson(
        BbsTokenModelLbSResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

BbsTokenModelCbSResp _$BbsTokenModelCbSRespFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelCbSResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsTokenModelCbSData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsTokenModelCbSRespToJson(
        BbsTokenModelCbSResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

BbsTokenModelLbSData _$BbsTokenModelLbSDataFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelLbSData(
      ltoken: json['ltoken'] as String,
    );

Map<String, dynamic> _$BbsTokenModelLbSDataToJson(
        BbsTokenModelLbSData instance) =>
    <String, dynamic>{
      'ltoken': instance.ltoken,
    };

BbsTokenModelCbSData _$BbsTokenModelCbSDataFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelCbSData(
      cookieToken: json['cookie_token'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$BbsTokenModelCbSDataToJson(
        BbsTokenModelCbSData instance) =>
    <String, dynamic>{
      'cookie_token': instance.cookieToken,
      'uid': instance.uid,
    };
