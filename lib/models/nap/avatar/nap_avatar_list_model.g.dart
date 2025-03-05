// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_avatar_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAvatarListModelResp _$NapAvatarListModelRespFromJson(
        Map<String, dynamic> json) =>
    NapAvatarListModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data:
          NapAvatarListModelRes.fromJson(json['data'] as Map<String, dynamic>),
    );

NapAvatarListModelRes _$NapAvatarListModelResFromJson(
        Map<String, dynamic> json) =>
    NapAvatarListModelRes(
      avatarList: (json['avatar_list'] as List<dynamic>)
          .map((e) => NapAvatarListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAvatarListModelResToJson(
        NapAvatarListModelRes instance) =>
    <String, dynamic>{
      'avatar_list': instance.avatarList.map((e) => e.toJson()).toList(),
    };

NapAvatarListModel _$NapAvatarListModelFromJson(Map<String, dynamic> json) =>
    NapAvatarListModel(
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
      rank: (json['rank'] as num).toInt(),
      isChosen: json['is_chosen'] as bool,
      roleSquareUrl: json['role_square_url'] as String,
      subElementType: (json['sub_element_type'] as num).toInt(),
    );

Map<String, dynamic> _$NapAvatarListModelToJson(NapAvatarListModel instance) =>
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
      'rank': instance.rank,
      'is_chosen': instance.isChosen,
      'role_square_url': instance.roleSquareUrl,
      'sub_element_type': instance.subElementType,
    };
