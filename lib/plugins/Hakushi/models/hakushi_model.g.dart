// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hakushi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HakushiModelCharacter _$HakushiModelCharacterFromJson(
        Map<String, dynamic> json) =>
    HakushiModelCharacter(
      code: json['code'] as String,
      rank: (json['rank'] as num?)?.toInt(),
      type: (json['type'] as num).toInt(),
      element: (json['element'] as num?)?.toInt(),
      hit: (json['hit'] as num).toInt(),
      camp: (json['camp'] as num).toInt(),
      icon: json['icon'] as String,
      en: json['EN'] as String,
      desc: json['desc'] as String,
      ko: json['KO'] as String,
      chs: json['CHS'] as String,
      ja: json['JA'] as String,
    );

Map<String, dynamic> _$HakushiModelCharacterToJson(
        HakushiModelCharacter instance) =>
    <String, dynamic>{
      'code': instance.code,
      'rank': instance.rank,
      'type': instance.type,
      'element': instance.element,
      'hit': instance.hit,
      'camp': instance.camp,
      'icon': instance.icon,
      'EN': instance.en,
      'desc': instance.desc,
      'KO': instance.ko,
      'CHS': instance.chs,
      'JA': instance.ja,
    };

HakushiModelWeapon _$HakushiModelWeaponFromJson(Map<String, dynamic> json) =>
    HakushiModelWeapon(
      icon: json['icon'] as String,
      rank: (json['rank'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      en: json['EN'] as String,
      desc: json['desc'] as String,
      ko: json['KO'] as String,
      chs: json['CHS'] as String,
      ja: json['JA'] as String,
    );

Map<String, dynamic> _$HakushiModelWeaponToJson(HakushiModelWeapon instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'rank': instance.rank,
      'type': instance.type,
      'EN': instance.en,
      'desc': instance.desc,
      'KO': instance.ko,
      'CHS': instance.chs,
      'JA': instance.ja,
    };

HakushiModelBangboo _$HakushiModelBangbooFromJson(Map<String, dynamic> json) =>
    HakushiModelBangboo(
      icon: json['icon'] as String,
      rank: (json['rank'] as num).toInt(),
      codeName: json['codename'] as String,
      en: json['EN'] as String,
      desc: json['desc'] as String,
      ko: json['KO'] as String,
      chs: json['CHS'] as String,
      ja: json['JA'] as String,
    );

Map<String, dynamic> _$HakushiModelBangbooToJson(
        HakushiModelBangboo instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'rank': instance.rank,
      'codename': instance.codeName,
      'EN': instance.en,
      'desc': instance.desc,
      'KO': instance.ko,
      'CHS': instance.chs,
      'JA': instance.ja,
    };
