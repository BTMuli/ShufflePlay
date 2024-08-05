// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_nap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNapModel _$UserNapModelFromJson(Map<String, dynamic> json) => UserNapModel(
      uid: json['uid'] as String,
      gameBiz: json['game_biz'] as String,
      gameUid: json['game_uid'] as String,
      isChosen: json['is_chosen'] as bool,
      isOfficial: json['is_official'] as bool,
      level: (json['level'] as num).toInt(),
      nickname: json['nickname'] as String,
      region: json['region'] as String,
      regionName: json['region_name'] as String,
    );

Map<String, dynamic> _$UserNapModelToJson(UserNapModel instance) =>
    <String, dynamic>{
      'game_biz': instance.gameBiz,
      'game_uid': instance.gameUid,
      'is_chosen': instance.isChosen,
      'is_official': instance.isOfficial,
      'level': instance.level,
      'nickname': instance.nickname,
      'region': instance.region,
      'region_name': instance.regionName,
      'uid': instance.uid,
    };
