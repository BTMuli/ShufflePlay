// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../bbs_base_model.dart';

/// 获取token相关的数据结构
part 'bbs_token_model.g.dart';

/// 根据stoken获取actionTicket返回
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsTokenModelAtSResp extends BBSResp<BbsTokenModelAtSData> {
  /// constructor
  BbsTokenModelAtSResp({
    required super.retcode,
    required super.message,
    required BbsTokenModelAtSData super.data,
  });

  /// from json
  factory BbsTokenModelAtSResp.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelAtSRespFromJson(json);
}

/// 根据stoken获取ltoken返回
@JsonSerializable(explicitToJson: true, createToJson: false)
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
@JsonSerializable(explicitToJson: true, createToJson: false)
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

/// 根据stoken获取actionTicket数据
@JsonSerializable()
class BbsTokenModelAtSData {
  /// ticket
  @JsonKey(name: 'ticket')
  String ticket;

  /// is_verified
  @JsonKey(name: 'is_verified')
  bool isVerified;

  /// account_info
  /// todo 这边没有用到，先不处理
  @JsonKey(name: 'account_info')
  dynamic accountInfo;

  /// constructor
  BbsTokenModelAtSData({
    required this.ticket,
    required this.isVerified,
    required this.accountInfo,
  });

  /// from json
  factory BbsTokenModelAtSData.fromJson(Map<String, dynamic> json) =>
      _$BbsTokenModelAtSDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsTokenModelAtSDataToJson(this);
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
