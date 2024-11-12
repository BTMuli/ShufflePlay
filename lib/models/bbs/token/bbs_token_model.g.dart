// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsTokenModelAtSResp _$BbsTokenModelAtSRespFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelAtSResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsTokenModelAtSData.fromJson(json['data'] as Map<String, dynamic>),
    );

BbsTokenModelLbSResp _$BbsTokenModelLbSRespFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelLbSResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsTokenModelLbSData.fromJson(json['data'] as Map<String, dynamic>),
    );

BbsTokenModelCbSResp _$BbsTokenModelCbSRespFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelCbSResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsTokenModelCbSData.fromJson(json['data'] as Map<String, dynamic>),
    );

BbsTokenModelAtSData _$BbsTokenModelAtSDataFromJson(
        Map<String, dynamic> json) =>
    BbsTokenModelAtSData(
      ticket: json['ticket'] as String,
      isVerified: json['is_verified'] as bool,
      accountInfo: json['account_info'],
    );

Map<String, dynamic> _$BbsTokenModelAtSDataToJson(
        BbsTokenModelAtSData instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
      'is_verified': instance.isVerified,
      'account_info': instance.accountInfo,
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
