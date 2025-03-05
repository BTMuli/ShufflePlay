// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_avatar_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAvatarDetailModelResp _$NapAvatarDetailModelRespFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapAvatarDetailModelRes.fromJson(
          json['data'] as Map<String, dynamic>),
    );

NapAvatarDetailModelRes _$NapAvatarDetailModelResFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelRes(
      avatarList: (json['avatar_list'] as List<dynamic>)
          .map((e) => NapAvatarDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipWiki: (json['equip_wiki'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      weaponWiki: (json['weapon_wiki'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      avatarWiki: (json['avatar_wiki'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      strategyWiki: (json['strategy_wiki'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      cultivateWiki: (json['cultivate_wiki'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      cultivateEquip: Map<String, String>.from(json['cultivate_equip'] as Map),
    );

Map<String, dynamic> _$NapAvatarDetailModelResToJson(
        NapAvatarDetailModelRes instance) =>
    <String, dynamic>{
      'avatar_list': instance.avatarList.map((e) => e.toJson()).toList(),
      'equip_wiki': instance.equipWiki,
      'weapon_wiki': instance.weaponWiki,
      'avatar_wiki': instance.avatarWiki,
      'strategy_wiki': instance.strategyWiki,
      'cultivate_wiki': instance.cultivateWiki,
      'cultivate_equip': instance.cultivateEquip,
    };

NapAvatarDetailModel _$NapAvatarDetailModelFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModel(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      nameMi18n: json['name_mi18n'] as String,
      fullNameMi18n: json['full_name_mi18n'] as String,
      elementType: (json['element_type'] as num).toInt(),
      campNameMi18n: json['camp_name_mi18n'] as String,
      avatarProfession: (json['avatar_profession'] as num).toInt(),
      rarity: json['rarity'] as String,
      groupIconPath: json['group_icon_path'] as String,
      hollowIconPath: json['hollow_icon_path'] as String,
      equip: (json['equip'] as List<dynamic>)
          .map((e) =>
              NapAvatarDetailModelEquip.fromJson(e as Map<String, dynamic>))
          .toList(),
      weapon: NapAvatarDetailModelWeapon.fromJson(
          json['weapon'] as Map<String, dynamic>),
      properties: (json['properties'] as List<dynamic>)
          .map((e) => NapBaseModelProperty.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>)
          .map((e) =>
              NapAvatarDetailModelSkill.fromJson(e as Map<String, dynamic>))
          .toList(),
      rank: (json['rank'] as num).toInt(),
      ranks: (json['ranks'] as List<dynamic>)
          .map((e) =>
              NapAvatarDetailModelRank.fromJson(e as Map<String, dynamic>))
          .toList(),
      roleVerticalPaintingUrl: json['role_vertical_painting_url'] as String,
      equipPlanInfo: json['equip_plan_info'],
      usFullName: json['us_full_name'] as String,
      verticalPaintingColor: json['vertical_painting_color'] as String,
      subElementType: (json['sub_element_type'] as num).toInt(),
      skinList: (json['skin_list'] as List<dynamic>)
          .map((e) =>
              NapAvatarDetailModelSkin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAvatarDetailModelToJson(
        NapAvatarDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name_mi18n': instance.nameMi18n,
      'full_name_mi18n': instance.fullNameMi18n,
      'element_type': instance.elementType,
      'camp_name_mi18n': instance.campNameMi18n,
      'avatar_profession': instance.avatarProfession,
      'rarity': instance.rarity,
      'group_icon_path': instance.groupIconPath,
      'hollow_icon_path': instance.hollowIconPath,
      'equip': instance.equip.map((e) => e.toJson()).toList(),
      'weapon': instance.weapon.toJson(),
      'properties': instance.properties.map((e) => e.toJson()).toList(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'rank': instance.rank,
      'ranks': instance.ranks.map((e) => e.toJson()).toList(),
      'role_vertical_painting_url': instance.roleVerticalPaintingUrl,
      'equip_plan_info': instance.equipPlanInfo,
      'us_full_name': instance.usFullName,
      'vertical_painting_color': instance.verticalPaintingColor,
      'sub_element_type': instance.subElementType,
      'skin_list': instance.skinList.map((e) => e.toJson()).toList(),
    };

NapAvatarDetailModelEquip _$NapAvatarDetailModelEquipFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelEquip(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      rarity: json['rarity'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((e) =>
              NapBaseModelPropertyFull.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainProperties: (json['main_properties'] as List<dynamic>)
          .map((e) =>
              NapBaseModelPropertyFull.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipSuit: NapAvatarDetailModelEquipSuit.fromJson(
          json['equip_suit'] as Map<String, dynamic>),
      equipmentType: (json['equipment_type'] as num).toInt(),
      invalidPropertyCnt: (json['invalid_property_cnt'] as num).toInt(),
      allHit: json['all_hit'] as bool,
    );

Map<String, dynamic> _$NapAvatarDetailModelEquipToJson(
        NapAvatarDetailModelEquip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'icon': instance.icon,
      'rarity': instance.rarity,
      'properties': instance.properties.map((e) => e.toJson()).toList(),
      'main_properties':
          instance.mainProperties.map((e) => e.toJson()).toList(),
      'equip_suit': instance.equipSuit.toJson(),
      'equipment_type': instance.equipmentType,
      'invalid_property_cnt': instance.invalidPropertyCnt,
      'all_hit': instance.allHit,
    };

NapAvatarDetailModelEquipSuit _$NapAvatarDetailModelEquipSuitFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelEquipSuit(
      suitId: (json['suit_id'] as num).toInt(),
      name: json['name'] as String,
      own: (json['own'] as num).toInt(),
      desc1: json['desc1'] as String,
      desc2: json['desc2'] as String,
    );

Map<String, dynamic> _$NapAvatarDetailModelEquipSuitToJson(
        NapAvatarDetailModelEquipSuit instance) =>
    <String, dynamic>{
      'suit_id': instance.suitId,
      'name': instance.name,
      'own': instance.own,
      'desc1': instance.desc1,
      'desc2': instance.desc2,
    };

NapAvatarDetailModelWeapon _$NapAvatarDetailModelWeaponFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelWeapon(
      id: (json['id'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      name: json['name'] as String,
      star: (json['star'] as num).toInt(),
      icon: json['icon'] as String,
      rarity: json['rarity'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((e) =>
              NapBaseModelPropertyFull.fromJson(e as Map<String, dynamic>))
          .toList(),
      mainProperties: (json['main_properties'] as List<dynamic>)
          .map((e) =>
              NapBaseModelPropertyFull.fromJson(e as Map<String, dynamic>))
          .toList(),
      talentTitle: json['talent_title'] as String,
      talentContent: json['talent_content'] as String,
      profession: (json['profession'] as num).toInt(),
    );

Map<String, dynamic> _$NapAvatarDetailModelWeaponToJson(
        NapAvatarDetailModelWeapon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'star': instance.star,
      'icon': instance.icon,
      'rarity': instance.rarity,
      'properties': instance.properties.map((e) => e.toJson()).toList(),
      'main_properties':
          instance.mainProperties.map((e) => e.toJson()).toList(),
      'talent_title': instance.talentTitle,
      'talent_content': instance.talentContent,
      'profession': instance.profession,
    };

NapAvatarDetailModelSkill _$NapAvatarDetailModelSkillFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelSkill(
      level: (json['level'] as num).toInt(),
      skillType: (json['skill_type'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              NapAvatarDetailModelSkillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAvatarDetailModelSkillToJson(
        NapAvatarDetailModelSkill instance) =>
    <String, dynamic>{
      'level': instance.level,
      'skill_type': instance.skillType,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

NapAvatarDetailModelSkillItem _$NapAvatarDetailModelSkillItemFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelSkillItem(
      title: json['title'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$NapAvatarDetailModelSkillItemToJson(
        NapAvatarDetailModelSkillItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
    };

NapAvatarDetailModelRank _$NapAvatarDetailModelRankFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelRank(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      desc: json['desc'] as String,
      pos: (json['pos'] as num).toInt(),
      isUnlocked: json['is_unlocked'] as bool,
    );

Map<String, dynamic> _$NapAvatarDetailModelRankToJson(
        NapAvatarDetailModelRank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'pos': instance.pos,
      'is_unlocked': instance.isUnlocked,
    };

NapAvatarDetailModelSkin _$NapAvatarDetailModelSkinFromJson(
        Map<String, dynamic> json) =>
    NapAvatarDetailModelSkin(
      isOriginal: json['is_original'] as bool,
      rarity: json['rarity'] as String,
      skinHollowIconPath: json['skin_hollow_icon_path'] as String,
      skinId: (json['skin_id'] as num).toInt(),
      skinName: json['skin_name'] as String,
      skinSquareUrl: json['skin_square_url'] as String,
      skinVerticalPaintingColor: json['skin_vertical_painting_color'] as String,
      skinVerticalPaintingUrl: json['skin_vertical_painting_url'] as String,
      unlocked: json['unlocked'] as bool,
    );

Map<String, dynamic> _$NapAvatarDetailModelSkinToJson(
        NapAvatarDetailModelSkin instance) =>
    <String, dynamic>{
      'is_original': instance.isOriginal,
      'rarity': instance.rarity,
      'skin_hollow_icon_path': instance.skinHollowIconPath,
      'skin_id': instance.skinId,
      'skin_name': instance.skinName,
      'skin_square_url': instance.skinSquareUrl,
      'skin_vertical_painting_color': instance.skinVerticalPaintingColor,
      'skin_vertical_painting_url': instance.skinVerticalPaintingUrl,
      'unlocked': instance.unlocked,
    };
