// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uigf_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UigfModelFull _$UigfModelFullFromJson(Map<String, dynamic> json) =>
    UigfModelFull(
      info: UigfModelInfo.fromJson(json['info'] as Map<String, dynamic>),
      nap: UigfModelNap.fromJson(json['nap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UigfModelFullToJson(UigfModelFull instance) =>
    <String, dynamic>{
      'info': instance.info.toJson(),
      'nap': instance.nap.toJson(),
    };

UigfModelInfo _$UigfModelInfoFromJson(Map<String, dynamic> json) =>
    UigfModelInfo(
      timestamp: json['export_timestamp'],
      app: json['export_app'] as String,
      appVersion: json['export_app_version'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$UigfModelInfoToJson(UigfModelInfo instance) =>
    <String, dynamic>{
      'export_timestamp': instance.timestamp,
      'export_app': instance.app,
      'export_app_version': instance.appVersion,
      'version': instance.version,
    };

UigfModelNap _$UigfModelNapFromJson(Map<String, dynamic> json) => UigfModelNap(
      items: (json['items'] as List<dynamic>)
          .map((e) => UigfModelNapItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UigfModelNapToJson(UigfModelNap instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

UigfModelNapItem _$UigfModelNapItemFromJson(Map<String, dynamic> json) =>
    UigfModelNapItem(
      uid: json['uid'],
      timezone: (json['timezone'] as num).toInt(),
      lang: $enumDecodeNullable(_$UigfLanguageEnumMap, json['lang']),
      list: (json['list'] as List<dynamic>)
          .map((e) => UigfModelNapItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UigfModelNapItemToJson(UigfModelNapItem instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'timezone': instance.timezone,
      'lang': _$UigfLanguageEnumMap[instance.lang],
      'list': instance.list.map((e) => e.toJson()).toList(),
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

UigfModelNapItemData _$UigfModelNapItemDataFromJson(
        Map<String, dynamic> json) =>
    UigfModelNapItemData(
      gachaId: json['gacha_id'] as String?,
      gachaType: $enumDecode(_$UigfNapPoolTypeEnumMap, json['gacha_type']),
      itemId: json['item_id'] as String,
      count: json['count'] as String?,
      time: json['time'] as String,
      name: json['name'] as String?,
      itemType: json['item_type'] as String?,
      rankType: json['rank_type'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UigfModelNapItemDataToJson(
        UigfModelNapItemData instance) =>
    <String, dynamic>{
      'gacha_id': instance.gachaId,
      'gacha_type': _$UigfNapPoolTypeEnumMap[instance.gachaType]!,
      'item_id': instance.itemId,
      'count': instance.count,
      'time': instance.time,
      'name': instance.name,
      'item_type': instance.itemType,
      'rank_type': instance.rankType,
      'id': instance.id,
    };

const _$UigfNapPoolTypeEnumMap = {
  UigfNapPoolType.normal: '1',
  UigfNapPoolType.upC: '2',
  UigfNapPoolType.upW: '3',
  UigfNapPoolType.bond: '5',
};
