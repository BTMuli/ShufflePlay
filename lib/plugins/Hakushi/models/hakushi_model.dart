// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// https://api.hakush.in/zzz/data 的数据模型
/// 包括角色、武器、物品、邦布等
/// 官网：https://zzz.hakush.in/
part 'hakushi_model.g.dart';

/// 角色返回数据是Map<String, HakushiModelCharacter>
@JsonSerializable()
class HakushiModelCharacter {
  /// code
  @JsonKey(name: 'code')
  final String code;

  /// rank
  @JsonKey(name: 'rank')
  final int? rank;

  /// type
  @JsonKey(name: 'type')
  final int type;

  /// element
  @JsonKey(name: 'element')
  final int? element;

  /// hit
  @JsonKey(name: 'hit')
  final int hit;

  /// camp
  @JsonKey(name: 'camp')
  final int camp;

  /// icon
  @JsonKey(name: 'icon')
  final String icon;

  /// EN
  @JsonKey(name: 'EN')
  final String en;

  /// desc
  @JsonKey(name: 'desc')
  final String desc;

  /// KO
  @JsonKey(name: 'KO')
  final String ko;

  /// CHS
  @JsonKey(name: 'CHS')
  final String chs;

  /// JA
  @JsonKey(name: 'JA')
  final String ja;

  /// constructor
  HakushiModelCharacter({
    required this.code,
    required this.rank,
    required this.type,
    required this.element,
    required this.hit,
    required this.camp,
    required this.icon,
    required this.en,
    required this.desc,
    required this.ko,
    required this.chs,
    required this.ja,
  });

  /// JSON 序列化
  factory HakushiModelCharacter.fromJson(Map<String, dynamic> json) =>
      _$HakushiModelCharacterFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$HakushiModelCharacterToJson(this);
}

/// 武器返回数据是Map<String, HakushiModelWeapon>
@JsonSerializable()
class HakushiModelWeapon {
  /// icon
  @JsonKey(name: 'icon')
  final String icon;

  /// rank
  @JsonKey(name: 'rank')
  final int rank;

  /// type
  @JsonKey(name: 'type')
  final int type;

  /// EN
  @JsonKey(name: 'EN')
  final String en;

  /// desc
  @JsonKey(name: 'desc')
  final String desc;

  /// KO
  @JsonKey(name: 'KO')
  final String ko;

  /// CHS
  @JsonKey(name: 'CHS')
  final String chs;

  /// JA
  @JsonKey(name: 'JA')
  final String ja;

  /// constructor
  HakushiModelWeapon({
    required this.icon,
    required this.rank,
    required this.type,
    required this.en,
    required this.desc,
    required this.ko,
    required this.chs,
    required this.ja,
  });

  /// JSON 序列化
  factory HakushiModelWeapon.fromJson(Map<String, dynamic> json) =>
      _$HakushiModelWeaponFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$HakushiModelWeaponToJson(this);
}

/// 邦布返回数据是Map<String, HakushiModelBangboo>
@JsonSerializable()
class HakushiModelBangboo {
  /// icon
  @JsonKey(name: 'icon')
  final String icon;

  /// rank
  @JsonKey(name: 'rank')
  final int rank;

  /// code
  @JsonKey(name: 'codename')
  final String codeName;

  /// EN
  @JsonKey(name: 'EN')
  final String en;

  /// desc
  @JsonKey(name: 'desc')
  final String desc;

  /// KO
  @JsonKey(name: 'KO')
  final String ko;

  /// CHS
  @JsonKey(name: 'CHS')
  final String chs;

  /// JA
  @JsonKey(name: 'JA')
  final String ja;

  /// constructor
  HakushiModelBangboo({
    required this.icon,
    required this.rank,
    required this.codeName,
    required this.en,
    required this.desc,
    required this.ko,
    required this.chs,
    required this.ja,
  });

  /// JSON 序列化
  factory HakushiModelBangboo.fromJson(Map<String, dynamic> json) =>
      _$HakushiModelBangbooFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$HakushiModelBangbooToJson(this);
}
