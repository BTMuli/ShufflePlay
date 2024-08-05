// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_authkey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAuthkeyModelResp _$NapAuthkeyModelRespFromJson(Map<String, dynamic> json) =>
    NapAuthkeyModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapAuthkeyModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NapAuthkeyModelRespToJson(
        NapAuthkeyModelResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

NapAuthkeyModelData _$NapAuthkeyModelDataFromJson(Map<String, dynamic> json) =>
    NapAuthkeyModelData(
      signType: (json['sign_type'] as num).toInt(),
      authkeyVer: (json['authkey_ver'] as num).toInt(),
      authkey: json['authkey'] as String,
    );

Map<String, dynamic> _$NapAuthkeyModelDataToJson(
        NapAuthkeyModelData instance) =>
    <String, dynamic>{
      'sign_type': instance.signType,
      'authkey_ver': instance.authkeyVer,
      'authkey': instance.authkey,
    };
