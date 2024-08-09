// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../../plugins/UIGF/models/uigf_enum.dart';
import '../../bbs/bbs_base_model.dart';

/// 祈愿返回数据模型
part 'nap_gacha_model.g.dart';

/// 祈愿返回数据模型
@JsonSerializable(explicitToJson: true)
class NapGachaModelResp extends BBSResp<NapGachaModelData> {
  NapGachaModelResp({
    required super.retcode,
    required super.message,
    required NapGachaModelData super.data,
  });

  factory NapGachaModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapGachaModelRespFromJson(json);
}

/// 祈愿返回数据模型data
@JsonSerializable(explicitToJson: true)
class NapGachaModelData {
  /// 祈愿数据
  @JsonKey(name: 'list')
  final List<NapGachaModel> list;

  /// 页面
  @JsonKey(name: 'page')
  final String page;

  /// region
  @JsonKey(name: 'region')
  final String region;

  /// region_time_zone
  @JsonKey(name: 'region_time_zone')
  final int regionTimeZone;

  /// size
  @JsonKey(name: 'size')
  final String size;

  /// constructor
  NapGachaModelData({
    required this.list,
    required this.page,
    required this.region,
    required this.regionTimeZone,
    required this.size,
  });

  /// fromJson
  factory NapGachaModelData.fromJson(Map<String, dynamic> json) =>
      _$NapGachaModelDataFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$NapGachaModelDataToJson(this);
}

/// 祈愿数据模型
@JsonSerializable()
class NapGachaModel {
  /// count
  @JsonKey(name: 'count')
  final String count;

  /// gacha_id
  @JsonKey(name: 'gacha_id')
  final String gachaId;

  /// gachaType
  @JsonKey(name: 'gacha_type')
  final UigfNapPoolType gachaType;

  /// id
  @JsonKey(name: 'id')
  final String id;

  /// item_id
  @JsonKey(name: 'item_id')
  final String itemId;

  /// item_type
  @JsonKey(name: 'item_type')
  final String itemType;

  /// lang
  @JsonKey(name: 'lang')
  final UigfLanguage lang;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// rank_type
  @JsonKey(name: 'rank_type')
  final String rankType;

  /// time
  @JsonKey(name: 'time')
  final String time;

  /// uid
  @JsonKey(name: 'uid')
  final String uid;

  /// constructor
  NapGachaModel({
    required this.count,
    required this.gachaId,
    required this.gachaType,
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.lang,
    required this.name,
    required this.rankType,
    required this.time,
    required this.uid,
  });

  /// fromJson
  factory NapGachaModel.fromJson(Map<String, dynamic> json) =>
      _$NapGachaModelFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$NapGachaModelToJson(this);
}
