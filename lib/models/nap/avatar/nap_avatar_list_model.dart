// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../bbs/bbs_base_model.dart';

/// 角色列表相关数据模型
part 'nap_avatar_list_model.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class NapAvatarListModelResp extends BBSResp<NapAvatarListModelRes> {
  NapAvatarListModelResp({
    required super.retcode,
    required super.message,
    required NapAvatarListModelRes super.data,
  });

  factory NapAvatarListModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarListModelRespFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NapAvatarListModelRes {
  /// avatar_list
  @JsonKey(name: 'avatar_list')
  final List<NapAvatarListModel> avatarList;

  /// constructor
  NapAvatarListModelRes({required this.avatarList});

  /// from json
  factory NapAvatarListModelRes.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarListModelResFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarListModelResToJson(this);
}

@JsonSerializable()
class NapAvatarListModel {
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
  /// TODO: 枚举字段
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

  /// rank
  @JsonKey(name: 'rank')
  final int rank;

  /// is_chosen
  @JsonKey(name: 'is_chosen')
  final bool isChosen;

  /// role_square_url
  @JsonKey(name: 'role_square_url')
  final String roleSquareUrl;

  /// sub_element_type
  @JsonKey(name: 'sub_element_type')
  final int subElementType;

  /// constructor
  NapAvatarListModel({
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
    required this.rank,
    required this.isChosen,
    required this.roleSquareUrl,
    required this.subElementType,
  });

  /// from json
  factory NapAvatarListModel.fromJson(Map<String, dynamic> json) =>
      _$NapAvatarListModelFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAvatarListModelToJson(this);
}
