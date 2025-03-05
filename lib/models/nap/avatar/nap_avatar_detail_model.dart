// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../bbs/bbs_base_model.dart';
import '../base/nap_base_model.dart';

/// 角色详情相关数据模型
part 'nap_avatar_detail_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class NapAvatarDetailModelResp extends BBSResp<NapAvatarDetailModelRes> {
  NapAvatarDetailModelResp({
    required super.retcode,
    required super.message,
    required NapAvatarDetailModelRes super.data,
  });

  factory NapAvatarDetailModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelRespFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarDetailModelRes {
  /// avatar_list
  @JsonKey(name: 'avatar_list')
  final List<NapAvatarDetailModel> avatarList;

  /// equip_wiki
  @JsonKey(name: 'equip_wiki')
  Map<String, String>? equipWiki;

  /// weapon_wiki
  @JsonKey(name: 'weapon_wiki')
  Map<String, String>? weaponWiki;

  /// avatar_wiki
  @JsonKey(name: 'avatar_wiki')
  Map<String, String>? avatarWiki;

  /// strategy_wiki
  @JsonKey(name: 'strategy_wiki')
  Map<String, String>? strategyWiki;

  /// cultivate_wiki
  @JsonKey(name: 'cultivate_wiki')
  Map<String, String>? cultivateWiki;

  /// cultivate_equip
  @JsonKey(name: 'cultivate_equip')
  Map<String, String> cultivateEquip;

  /// constructor
  NapAvatarDetailModelRes({
    required this.avatarList,
    required this.equipWiki,
    required this.weaponWiki,
    required this.avatarWiki,
    required this.strategyWiki,
    required this.cultivateWiki,
    required this.cultivateEquip,
  });

  /// from json
  factory NapAvatarDetailModelRes.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelResFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarDetailModel {
  /// id
  @JsonKey(name: 'id')
  final int id;

  /// level
  @JsonKey(name: 'level')
  final int level;

  /// name_mi18n
  @JsonKey(name: 'name_mi18n')
  final String nameMi18n;

  /// full_name_mi18n
  @JsonKey(name: 'full_name_mi18n')
  final String fullNameMi18n;

  /// element_type
  @JsonKey(name: 'element_type')
  final int elementType;

  /// camp_name_mi18n
  @JsonKey(name: 'camp_name_mi18n')
  final String campNameMi18n;

  /// avatar_profession
  @JsonKey(name: 'avatar_profession')
  final int avatarProfession;

  /// rarity
  @JsonKey(name: 'rarity')
  final String rarity;

  /// group_icon_path
  @JsonKey(name: 'group_icon_path')
  final String groupIconPath;

  /// hollow_icon_path
  @JsonKey(name: 'hollow_icon_path')
  final String hollowIconPath;

  /// equip
  @JsonKey(name: 'equip')
  final List<NapAvatarDetailModelEquip> equip;

  /// weapon
  @JsonKey(name: 'weapon')
  final NapAvatarDetailModelWeapon weapon;

  /// properties
  @JsonKey(name: 'properties')
  final List<NapBaseModelProperty> properties;

  /// skills
  @JsonKey(name: 'skills')
  final List<NapAvatarDetailModelSkill> skills;

  /// rank
  @JsonKey(name: 'rank')
  final int rank;

  /// ranks
  @JsonKey(name: 'ranks')
  final List<NapAvatarDetailModelRank> ranks;

  /// role_vertical_painting_url
  @JsonKey(name: "role_vertical_painting_url")
  final String roleVerticalPaintingUrl;

  /// equip_plan_info
  /// TODO: 未使用
  @JsonKey(name: 'equip_plan_info')
  dynamic equipPlanInfo;

  /// us_full_name
  @JsonKey(name: 'us_full_name')
  final String usFullName;

  /// vertical_painting_color
  @JsonKey(name: 'vertical_painting_color')
  final String verticalPaintingColor;

  /// sub_element_type
  @JsonKey(name: 'sub_element_type')
  final int subElementType;

  /// skin_list
  @JsonKey(name: 'skin_list')
  final List<NapAvatarDetailModelSkin> skinList;

  /// constructor
  NapAvatarDetailModel({
    required this.id,
    required this.level,
    required this.nameMi18n,
    required this.fullNameMi18n,
    required this.elementType,
    required this.campNameMi18n,
    required this.avatarProfession,
    required this.rarity,
    required this.groupIconPath,
    required this.hollowIconPath,
    required this.equip,
    required this.weapon,
    required this.properties,
    required this.skills,
    required this.rank,
    required this.ranks,
    required this.roleVerticalPaintingUrl,
    required this.equipPlanInfo,
    required this.usFullName,
    required this.verticalPaintingColor,
    required this.subElementType,
    required this.skinList,
  });

  /// from json
  factory NapAvatarDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarDetailModelEquip {
  /// id
  @JsonKey(name: 'id')
  final int id;

  /// level
  @JsonKey(name: 'level')
  final int level;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// icon
  @JsonKey(name: 'icon')
  final String icon;

  /// rarity
  @JsonKey(name: 'rarity')
  final String rarity;

  /// properties
  @JsonKey(name: 'properties')
  final List<NapBaseModelPropertyFull> properties;

  /// main_properties
  @JsonKey(name: 'main_properties')
  final List<NapBaseModelPropertyFull> mainProperties;

  /// equip_suit
  @JsonKey(name: 'equip_suit')
  final NapAvatarDetailModelEquipSuit equipSuit;

  /// equipment_type
  @JsonKey(name: 'equipment_type')
  final int equipmentType;

  /// invalid_property_cnt
  @JsonKey(name: 'invalid_property_cnt')
  final int invalidPropertyCnt;

  /// all_hit
  @JsonKey(name: 'all_hit')
  final bool allHit;

  /// constructor
  NapAvatarDetailModelEquip({
    required this.id,
    required this.level,
    required this.name,
    required this.icon,
    required this.rarity,
    required this.properties,
    required this.mainProperties,
    required this.equipSuit,
    required this.equipmentType,
    required this.invalidPropertyCnt,
    required this.allHit,
  });

  /// from json
  factory NapAvatarDetailModelEquip.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelEquipFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelEquipToJson(this);
}

@JsonSerializable()
class NapAvatarDetailModelEquipSuit {
  /// suit_id
  @JsonKey(name: 'suit_id')
  final int suitId;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// own
  @JsonKey(name: 'own')
  final int own;

  /// desc1
  @JsonKey(name: 'desc1')
  final String desc1;

  /// desc2
  @JsonKey(name: 'desc2')
  final String desc2;

  /// constructor
  NapAvatarDetailModelEquipSuit({
    required this.suitId,
    required this.name,
    required this.own,
    required this.desc1,
    required this.desc2,
  });

  /// from json
  factory NapAvatarDetailModelEquipSuit.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelEquipSuitFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelEquipSuitToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarDetailModelWeapon {
  /// id
  @JsonKey(name: 'id')
  final int id;

  /// level
  @JsonKey(name: 'level')
  final int level;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// star
  @JsonKey(name: 'star')
  final int star;

  /// icon
  @JsonKey(name: 'icon')
  final String icon;

  /// rarity
  @JsonKey(name: 'rarity')
  final String rarity;

  /// properties
  @JsonKey(name: 'properties')
  final List<NapBaseModelPropertyFull> properties;

  /// main_properties
  @JsonKey(name: 'main_properties')
  final List<NapBaseModelPropertyFull> mainProperties;

  /// talent_title
  @JsonKey(name: 'talent_title')
  final String talentTitle;

  /// talent_content
  @JsonKey(name: 'talent_content')
  final String talentContent;

  /// profession
  @JsonKey(name: 'profession')
  final int profession;

  /// constructor
  NapAvatarDetailModelWeapon({
    required this.id,
    required this.level,
    required this.name,
    required this.star,
    required this.icon,
    required this.rarity,
    required this.properties,
    required this.mainProperties,
    required this.talentTitle,
    required this.talentContent,
    required this.profession,
  });

  /// from json
  factory NapAvatarDetailModelWeapon.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelWeaponFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelWeaponToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarDetailModelSkill {
  /// level
  @JsonKey(name: 'level')
  final int level;

  /// skill_type
  @JsonKey(name: 'skill_type')
  final int skillType;

  /// items
  @JsonKey(name: 'items')
  final List<NapAvatarDetailModelSkillItem> items;

  /// constructor
  NapAvatarDetailModelSkill({
    required this.level,
    required this.skillType,
    required this.items,
  });

  /// from json
  factory NapAvatarDetailModelSkill.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelSkillFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelSkillToJson(this);
}

@JsonSerializable()
class NapAvatarDetailModelSkillItem {
  /// title
  @JsonKey(name: 'title')
  final String title;

  /// text
  @JsonKey(name: 'text')
  final String text;

  /// constructor
  NapAvatarDetailModelSkillItem({
    required this.title,
    required this.text,
  });

  /// from json
  factory NapAvatarDetailModelSkillItem.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelSkillItemFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelSkillItemToJson(this);
}

@JsonSerializable()
class NapAvatarDetailModelRank {
  /// id
  @JsonKey(name: 'id')
  final int id;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// desc
  @JsonKey(name: 'desc')
  final String desc;

  /// pos
  @JsonKey(name: 'pos')
  final int pos;

  /// is_unlocked
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;

  /// constructor
  NapAvatarDetailModelRank({
    required this.id,
    required this.name,
    required this.desc,
    required this.pos,
    required this.isUnlocked,
  });

  /// from json
  factory NapAvatarDetailModelRank.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelRankFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelRankToJson(this);
}

@JsonSerializable()
class NapAvatarDetailModelSkin {
  /// is_original
  @JsonKey(name: 'is_original')
  final bool isOriginal;

  /// rarity
  @JsonKey(name: 'rarity')
  final String rarity;

  /// skin_hollow_icon_path
  @JsonKey(name: 'skin_hollow_icon_path')
  final String skinHollowIconPath;

  /// skin_id
  @JsonKey(name: 'skin_id')
  final int skinId;

  /// skin_name
  @JsonKey(name: 'skin_name')
  final String skinName;

  /// skin_square_url
  @JsonKey(name: 'skin_square_url')
  final String skinSquareUrl;

  /// skin_vertical_painting_color
  @JsonKey(name: 'skin_vertical_painting_color')
  final String skinVerticalPaintingColor;

  /// skin_vertical_painting_url
  @JsonKey(name: 'skin_vertical_painting_url')
  final String skinVerticalPaintingUrl;

  /// unlocked
  @JsonKey(name: 'unlocked')
  final bool unlocked;

  /// constructor
  NapAvatarDetailModelSkin({
    required this.isOriginal,
    required this.rarity,
    required this.skinHollowIconPath,
    required this.skinId,
    required this.skinName,
    required this.skinSquareUrl,
    required this.skinVerticalPaintingColor,
    required this.skinVerticalPaintingUrl,
    required this.unlocked,
  });

  /// from json
  factory NapAvatarDetailModelSkin.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarDetailModelSkinFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarDetailModelSkinToJson(this);
}
