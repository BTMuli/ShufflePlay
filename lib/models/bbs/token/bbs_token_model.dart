// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../bbs_base_model.dart';

/// 获取token相关的数据结构
part 'bbs_token_model.g.dart';

/// 根据stoken获取ltoken返回
@JsonSerializable(createToJson: true)
class BbsTokenModelLbSResp extends BBSResp<BbsTokenModelLbSData> {
  /// constructor
  BbsTokenModelLbSResp({
    required super.retcode,
    required super.message,
    required BbsTokenModelLbSData super.data,
  });

  /// from json
  factory BbsTokenModelLbSResp.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelLbSRespFromJson(json);
}

/// 根据stoken获取cookieToken返回
@JsonSerializable(createToJson: true)
class BbsTokenModelCbSResp extends BBSResp<BbsTokenModelCbSData> {
  /// constructor
  BbsTokenModelCbSResp({
    required super.retcode,
    required super.message,
    required BbsTokenModelCbSData super.data,
  });

  /// from json
  factory BbsTokenModelCbSResp.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelCbSRespFromJson(json);
}

/// 根据stoken获取ltoken数据
@JsonSerializable()
class BbsTokenModelLbSData {
  /// ltoken
  @JsonKey(name: 'ltoken')
  String ltoken;

  /// constructor
  BbsTokenModelLbSData({
    required this.ltoken,
  });

  /// from json
  factory BbsTokenModelLbSData.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelLbSDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsTokenModelLbSDataToJson(this);
}

/// 根据stoken获取cookieToken数据
@JsonSerializable()
class BbsTokenModelCbSData {
  /// cookieToken
  @JsonKey(name: 'cookie_token')
  String cookieToken;

  /// uid
  @JsonKey(name: 'uid')
  String uid;

  /// constructor
  BbsTokenModelCbSData({
    required this.cookieToken,
    required this.uid,
  });

  /// from json
  factory BbsTokenModelCbSData.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelCbSDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsTokenModelCbSDataToJson(this);
}
