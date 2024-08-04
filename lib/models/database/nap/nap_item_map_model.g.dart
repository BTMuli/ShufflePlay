// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_item_map_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapItemMapModel _$NapItemMapModelFromJson(Map<String, dynamic> json) =>
    NapItemMapModel(
      itemId: json['item_id'] as String,
      rank: json['rank'] as String,
      type: $enumDecode(_$NapItemMapTypeEnumMap, json['type']),
      locale: NapItemMapLocale.fromJson(json['locale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NapItemMapModelToJson(NapItemMapModel instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'rank': instance.rank,
      'type': _$NapItemMapTypeEnumMap[instance.type]!,
      'locale': instance.locale.toJson(),
    };

const _$NapItemMapTypeEnumMap = {
  NapItemMapType.character: 'character',
  NapItemMapType.weapon: 'weapon',
  NapItemMapType.bangboo: 'bangboo',
};

NapItemMapLocale _$NapItemMapLocaleFromJson(Map<String, dynamic> json) =>
    NapItemMapLocale(
      zh: json['zh'] as String,
      ja: json['ja'] as String,
      en: json['en'] as String,
      ko: json['ko'] as String,
    );

Map<String, dynamic> _$NapItemMapLocaleToJson(NapItemMapLocale instance) =>
    <String, dynamic>{
      'zh': instance.zh,
      'ja': instance.ja,
      'en': instance.en,
      'ko': instance.ko,
    };
