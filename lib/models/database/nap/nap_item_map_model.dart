// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../../plugins/Hakushi/models/hakushi_model.dart';
import 'nap_item_map_enum.dart';

/// NapItemMap 表的数据模型
/// 该表在 lib/database/nap/nap_item_map.dart 中定义
part 'nap_item_map_model.g.dart';

/// NapItemMap 表的数据模型
@JsonSerializable(explicitToJson: true)
class NapItemMapModel {
  /// 物品id
  @JsonKey(name: 'item_id')
  final String itemId;

  /// 物品等级
  @JsonKey(name: 'rank')
  final String rank;

  /// 物品类型
  @JsonKey(name: 'type')
  final NapItemMapType type;

  /// 物品地区
  @JsonKey(name: 'locale')
  final NapItemMapLocale locale;

  /// 构造函数
  NapItemMapModel({
    required this.itemId,
    required this.rank,
    required this.type,
    required this.locale,
  });

  /// JSON 序列化
  factory NapItemMapModel.fromJson(Map<String, dynamic> json) =>
      _$NapItemMapModelFromJson(json);

  /// from sql json
  factory NapItemMapModel.fromSqlJson(Map<String, dynamic> json) {
    var locale = jsonDecode(json['locale']);
    return NapItemMapModel(
      itemId: json['item_id'],
      rank: json['rank'],
      type: json['type'],
      locale: NapItemMapLocale.fromJson(locale),
    );
  }

  /// from hakushiCharacter
  factory NapItemMapModel.fromHakushiCharacter(
    String itemId,
    HakushiModelCharacter data,
  ) {
    return NapItemMapModel(
      itemId: itemId,
      rank: data.rank.toString(),
      type: NapItemMapType.character,
      locale: NapItemMapLocale(
        zh: data.chs,
        ja: data.ja,
        en: data.en,
        ko: data.ko,
      ),
    );
  }

  /// from hakushiWeapon
  factory NapItemMapModel.fromHakushiWeapon(
    String itemId,
    HakushiModelWeapon data,
  ) {
    return NapItemMapModel(
      itemId: itemId,
      rank: data.rank.toString(),
      type: NapItemMapType.weapon,
      locale: NapItemMapLocale(
        zh: data.chs,
        ja: data.ja,
        en: data.en,
        ko: data.ko,
      ),
    );
  }

  /// from hakushiBangboo
  factory NapItemMapModel.fromHakushiBangboo(
    String itemId,
    HakushiModelBangboo data,
  ) {
    return NapItemMapModel(
      itemId: itemId,
      rank: data.rank.toString(),
      type: NapItemMapType.bangboo,
      locale: NapItemMapLocale(
        zh: data.chs,
        ja: data.ja,
        en: data.en,
        ko: data.ko,
      ),
    );
  }

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$NapItemMapModelToJson(this);

  /// to sql json
  Map<String, dynamic> toSqlJson() {
    return {
      'item_id': itemId,
      'rank': rank,
      'type': type.value,
      'locale': jsonEncode(locale),
    };
  }
}

/// 物品地区
@JsonSerializable()
class NapItemMapLocale {
  /// 中文翻译
  @JsonKey(name: 'zh')
  final String zh;

  /// 日文翻译
  @JsonKey(name: 'ja')
  final String ja;

  /// 英文翻译
  @JsonKey(name: 'en')
  final String en;

  /// 韩文翻译
  @JsonKey(name: 'ko')
  final String ko;

  /// 构造函数
  NapItemMapLocale({
    required this.zh,
    required this.ja,
    required this.en,
    required this.ko,
  });

  /// JSON 序列化
  factory NapItemMapLocale.fromJson(Map<String, dynamic> json) =>
      _$NapItemMapLocaleFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$NapItemMapLocaleToJson(this);
}
