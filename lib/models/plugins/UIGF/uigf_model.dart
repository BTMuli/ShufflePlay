// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'uigf_enum.dart';

/// UIGF 相关的数据结构
part 'uigf_model.g.dart';

/// UIGF JSON
@JsonSerializable(explicitToJson: true)
class UigfModelFull {
  /// UIGF 数据
  @JsonKey(name: 'info')
  UigfModelInfo info;

  /// zzz祈愿数据
  @JsonKey(name: 'nap')
  UigfModelNap nap;

  /// constructor
  UigfModelFull({
    required this.info,
    required this.nap,
  });

  /// from json
  factory UigfModelFull.fromJson(Map<String, dynamic> json) =>
      _$UigfModelFullFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$UigfModelFullToJson(this);
}

/// UIGF 数据
@JsonSerializable()
class UigfModelInfo {
  /// 导出时间戳，字符串或数字
  @JsonKey(name: 'export_timestamp')
  dynamic timestamp;

  /// 导出应用
  @JsonKey(name: 'export_app')
  String app;

  /// 导出应用的版本
  @JsonKey(name: 'export_app_version')
  String appVersion;

  /// UIGF版本
  @JsonKey(name: 'version')
  String version;

  /// constructor
  UigfModelInfo({
    required this.timestamp,
    required this.app,
    required this.appVersion,
    required this.version,
  });

  /// from json
  factory UigfModelInfo.fromJson(Map<String, dynamic> json) =>
      _$UigfModelInfoFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$UigfModelInfoToJson(this);
}

/// zzz祈愿数据
@JsonSerializable(explicitToJson: true)
class UigfModelNap {
  /// 列表数据
  @JsonKey(name: 'items')
  List<UigfModelNapItem> items;

  /// constructor
  UigfModelNap({
    required this.items,
  });

  /// from json
  factory UigfModelNap.fromJson(Map<String, dynamic> json) =>
      _$UigfModelNapFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$UigfModelNapToJson(this);
}

/// zzz祈愿数据条目
@JsonSerializable(explicitToJson: true)
class UigfModelNapItem {
  /// uid，数字或字符串
  @JsonKey(name: 'uid')
  dynamic uid;

  /// 时区
  @JsonKey(name: 'timezone')
  int timezone;

  /// 语言，枚举类
  @JsonKey(name: 'lang')
  UigfLanguage? lang;

  /// 数据
  @JsonKey(name: 'list')
  List<UigfModelNapItemData> list;

  /// constructor
  UigfModelNapItem({
    required this.uid,
    required this.timezone,
    this.lang,
    required this.list,
  });

  /// from json
  factory UigfModelNapItem.fromJson(Map<String, dynamic> json) =>
      _$UigfModelNapItemFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$UigfModelNapItemToJson(this);
}

/// zzz祈愿数据条目数据
@JsonSerializable()
class UigfModelNapItemData {
  /// 卡池id
  @JsonKey(name: 'gacha_id')
  String? gachaId;

  /// 卡池类型
  @JsonKey(name: 'gacha_type')
  UigfNapPoolType gachaType;

  /// 物品id
  @JsonKey(name: 'item_id')
  String itemId;

  /// 物品数量
  @JsonKey(name: 'count')
  String? count;

  /// 时间
  @JsonKey(name: 'time')
  String time;

  /// 名称
  @JsonKey(name: 'name')
  String? name;

  /// 物品类型
  @JsonKey(name: 'item_type')
  String? itemType;

  /// 星级
  @JsonKey(name: 'rank_type')
  String? rankType;

  /// id
  @JsonKey(name: 'id')
  String id;

  /// constructor
  UigfModelNapItemData({
    this.gachaId,
    required this.gachaType,
    required this.itemId,
    this.count,
    required this.time,
    this.name,
    this.itemType,
    this.rankType,
    required this.id,
  });

  /// from json
  factory UigfModelNapItemData.fromJson(Map<String, dynamic> json) =>
      _$UigfModelNapItemDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$UigfModelNapItemDataToJson(this);
}
