// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../bbs/bbs_base_model.dart';

/// 获取用户游戏账号信息返回
part 'nap_account_model.g.dart';

/// 用户游戏账号信息返回
@JsonSerializable(explicitToJson: true, createToJson: false)
class NapAccountModelResp extends BBSResp<NapAccountModelData> {
  /// constructor
  NapAccountModelResp({
    required super.retcode,
    required super.message,
    required NapAccountModelData super.data,
  });

  /// from json
  factory NapAccountModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAccountModelRespFromJson(json);
}

/// 用户游戏账号信息数据
@JsonSerializable(explicitToJson: true)
class NapAccountModelData {
  /// list
  @JsonKey(name: 'list')
  final List<NapAccountModel> list;

  /// constructor
  NapAccountModelData({
    required this.list,
  });

  /// from json
  factory NapAccountModelData.fromJson(Map<String, dynamic> json) =>
      _$NapAccountModelDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAccountModelDataToJson(this);
}

/// 用户游戏账号信息
@JsonSerializable()
class NapAccountModel {
  /// game_biz
  @JsonKey(name: 'game_biz')
  final String gameBiz;

  /// game_uid
  @JsonKey(name: 'game_uid')
  final String gameUid;

  /// is_chosen
  @JsonKey(name: 'is_chosen')
  final bool isChosen;

  /// is_official
  @JsonKey(name: 'is_official')
  final bool isOfficial;

  /// level
  @JsonKey(name: 'level')
  final int level;

  /// nickname
  @JsonKey(name: 'nickname')
  final String nickname;

  /// region
  @JsonKey(name: 'region')
  final String region;

  /// region_name
  @JsonKey(name: 'region_name')
  final String regionName;

  /// constructor
  NapAccountModel({
    required this.gameBiz,
    required this.gameUid,
    required this.isChosen,
    required this.isOfficial,
    required this.level,
    required this.nickname,
    required this.region,
    required this.regionName,
  });

  /// from json
  factory NapAccountModel.fromJson(Map<String, dynamic> json) =>
      _$NapAccountModelFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAccountModelToJson(this);
}
