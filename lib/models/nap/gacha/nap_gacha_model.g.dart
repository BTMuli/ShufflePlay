// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_gacha_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapGachaModelResp _$NapGachaModelRespFromJson(Map<String, dynamic> json) =>
    NapGachaModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapGachaModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NapGachaModelRespToJson(NapGachaModelResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

NapGachaModelData _$NapGachaModelDataFromJson(Map<String, dynamic> json) =>
    NapGachaModelData(
      list: (json['list'] as List<dynamic>)
          .map((e) => NapGachaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as String,
      region: json['region'] as String,
      regionTimeZone: (json['region_time_zone'] as num).toInt(),
      size: json['size'] as String,
    );

Map<String, dynamic> _$NapGachaModelDataToJson(NapGachaModelData instance) =>
    <String, dynamic>{
      'list': instance.list.map((e) => e.toJson()).toList(),
      'page': instance.page,
      'region': instance.region,
      'region_time_zone': instance.regionTimeZone,
      'size': instance.size,
    };

NapGachaModel _$NapGachaModelFromJson(Map<String, dynamic> json) =>
    NapGachaModel(
      count: json['count'] as String,
      gachaId: json['gacha_id'] as String,
      gachaType: $enumDecode(_$UigfNapPoolTypeEnumMap, json['gacha_type']),
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as String,
      lang: $enumDecode(_$UigfLanguageEnumMap, json['lang']),
      name: json['name'] as String,
      rankType: json['rank_type'] as String,
      time: json['time'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$NapGachaModelToJson(NapGachaModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'gacha_id': instance.gachaId,
      'gacha_type': _$UigfNapPoolTypeEnumMap[instance.gachaType]!,
      'id': instance.id,
      'item_id': instance.itemId,
      'item_type': instance.itemType,
      'lang': _$UigfLanguageEnumMap[instance.lang]!,
      'name': instance.name,
      'rank_type': instance.rankType,
      'time': instance.time,
      'uid': instance.uid,
    };

const _$UigfNapPoolTypeEnumMap = {
  UigfNapPoolType.normal: '1',
  UigfNapPoolType.upC: '2',
  UigfNapPoolType.upW: '3',
  UigfNapPoolType.bond: '5',
};

const _$UigfLanguageEnumMap = {
  UigfLanguage.de: 'de-de',
  UigfLanguage.en: 'en-us',
  UigfLanguage.es: 'es-es',
  UigfLanguage.fr: 'fr-fr',
  UigfLanguage.id: 'id-id',
  UigfLanguage.it: 'it-it',
  UigfLanguage.ja: 'ja-jp',
  UigfLanguage.ko: 'ko-kr',
  UigfLanguage.pt: 'pt-pt',
  UigfLanguage.ru: 'ru-ru',
  UigfLanguage.th: 'th-th',
  UigfLanguage.tr: 'tr-tr',
  UigfLanguage.vi: 'vi-vn',
  UigfLanguage.zhHans: 'zh-cn',
  UigfLanguage.zhHant: 'zh-tw',
};
