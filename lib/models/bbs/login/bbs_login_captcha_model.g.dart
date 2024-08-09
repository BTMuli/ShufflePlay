// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_login_captcha_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsLoginCaptchaResp _$BbsLoginCaptchaRespFromJson(Map<String, dynamic> json) =>
    BbsLoginCaptchaResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsLoginCaptchaData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsLoginCaptchaRespToJson(
        BbsLoginCaptchaResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

BbsLoginCaptchaData _$BbsLoginCaptchaDataFromJson(Map<String, dynamic> json) =>
    BbsLoginCaptchaData(
      sentNew: json['sent_new'] as String,
      countdown: json['countdown'] as String,
      actionType: json['action_type'] as String,
    );

Map<String, dynamic> _$BbsLoginCaptchaDataToJson(
        BbsLoginCaptchaData instance) =>
    <String, dynamic>{
      'sent_new': instance.sentNew,
      'countdown': instance.countdown,
      'action_type': instance.actionType,
    };
