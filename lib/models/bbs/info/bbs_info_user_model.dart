// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../bbs_base_model.dart';

/// 获取用户信息的返回数据模型
part 'bbs_info_user_model.g.dart';

/// 获取用户信息的返回数据模型
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsInfoUserModelResp extends BBSResp<BbsInfoUserModelDataFull> {
  /// constructor
  BbsInfoUserModelResp({
    required super.retcode,
    required super.message,
    required BbsInfoUserModelDataFull super.data,
  });

  /// JSON 反序列化
  factory BbsInfoUserModelResp.fromJson(Map<String, dynamic> json) =>
      _$BbsInfoUserModelRespFromJson(json);
}

/// 获取用户信息的返回数据模型
@JsonSerializable(explicitToJson: true)
class BbsInfoUserModelDataFull {
  /// user_info
  @JsonKey(name: 'user_info')
  final BbsInfoUserModelData userInfo;

  /// constructor
  BbsInfoUserModelDataFull({required this.userInfo});

  /// JSON 反序列化
  factory BbsInfoUserModelDataFull.fromJson(Map<String, dynamic> json) =>
      _$BbsInfoUserModelDataFullFromJson(json);

  /// JSON 序列化
  Map<String, dynamic> toJson() => _$BbsInfoUserModelDataFullToJson(this);
}

/// 只写了需要的，不需要的用dynamic代替
@JsonSerializable(explicitToJson: true)
class BbsInfoUserModelData {
  /// uid
  @JsonKey(name: 'uid')
  final String uid;

  /// nickname
  @JsonKey(name: 'nickname')
  final String nickname;

  /// introduce
  @JsonKey(name: 'introduce')
  final String introduce;

  /// avatar
  @JsonKey(name: 'avatar')
  final String avatar;

  /// gender 0: 男 1: 女
  @JsonKey(name: 'gender')
  final int gender;

  /// avatar_url
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  /// constructor
  BbsInfoUserModelData({
    required this.uid,
    required this.nickname,
    required this.introduce,
    required this.avatar,
    required this.gender,
    required this.avatarUrl,
  });

  /// JSON 反序列化
  factory BbsInfoUserModelData.fromJson(Map<String, dynamic> json) =>
      _$BbsInfoUserModelDataFromJson(json);

  /// JSON 序列化
  Map<String, dynamic> toJson() => _$BbsInfoUserModelDataToJson(this);
}
