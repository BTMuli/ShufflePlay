// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_info_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsInfoUserModelResp _$BbsInfoUserModelRespFromJson(
        Map<String, dynamic> json) =>
    BbsInfoUserModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsInfoUserModelDataFull.fromJson(
          json['data'] as Map<String, dynamic>),
    );

BbsInfoUserModelDataFull _$BbsInfoUserModelDataFullFromJson(
        Map<String, dynamic> json) =>
    BbsInfoUserModelDataFull(
      userInfo: BbsInfoUserModelData.fromJson(
          json['user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsInfoUserModelDataFullToJson(
        BbsInfoUserModelDataFull instance) =>
    <String, dynamic>{
      'user_info': instance.userInfo.toJson(),
    };

BbsInfoUserModelData _$BbsInfoUserModelDataFromJson(
        Map<String, dynamic> json) =>
    BbsInfoUserModelData(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      introduce: json['introduce'] as String,
      avatar: json['avatar'] as String,
      gender: (json['gender'] as num).toInt(),
      avatarUrl: json['avatar_url'] as String,
    );

Map<String, dynamic> _$BbsInfoUserModelDataToJson(
        BbsInfoUserModelData instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'introduce': instance.introduce,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'avatar_url': instance.avatarUrl,
    };
