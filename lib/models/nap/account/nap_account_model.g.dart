// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAccountModelResp _$NapAccountModelRespFromJson(Map<String, dynamic> json) =>
    NapAccountModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapAccountModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

NapAccountModelData _$NapAccountModelDataFromJson(Map<String, dynamic> json) =>
    NapAccountModelData(
      list: (json['list'] as List<dynamic>)
          .map((e) => NapAccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAccountModelDataToJson(
        NapAccountModelData instance) =>
    <String, dynamic>{
      'list': instance.list.map((e) => e.toJson()).toList(),
    };

NapAccountModel _$NapAccountModelFromJson(Map<String, dynamic> json) =>
    NapAccountModel(
      gameBiz: json['game_biz'] as String,
      gameUid: json['game_uid'] as String,
      isChosen: json['is_chosen'] as bool,
      isOfficial: json['is_official'] as bool,
      level: (json['level'] as num).toInt(),
      nickname: json['nickname'] as String,
      region: json['region'] as String,
      regionName: json['region_name'] as String,
    );

Map<String, dynamic> _$NapAccountModelToJson(NapAccountModel instance) =>
    <String, dynamic>{
      'game_biz': instance.gameBiz,
      'game_uid': instance.gameUid,
      'is_chosen': instance.isChosen,
      'is_official': instance.isOfficial,
      'level': instance.level,
      'nickname': instance.nickname,
      'region': instance.region,
      'region_name': instance.regionName,
    };
