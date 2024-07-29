// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// UserBBS 表的数据模型
/// 该表在 lib/database/user/user_bbs.dart 中定义
part 'user_bbs_model.g.dart';

/// UserBBS 表的数据模型
@JsonSerializable(explicitToJson: true)
class UserBBSModel {
  /// 自增ID
  @JsonKey(name: 'id')
  final int id;

  /// 用户ID
  @JsonKey(name: 'uid')
  final String uid;

  /// Cookie
  @JsonKey(name: 'cookie')
  final UserBBSModelCookie? cookie;

  /// 手机号
  @JsonKey(name: 'phone')
  final String? phone;

  /// 部分必要的用户信息
  final UserBBSModelBrief? brief;

  /// 更新时间，时间戳
  late int updatedAt;

  /// 构造函数
  UserBBSModel({
    required this.id,
    required this.uid,
    required this.cookie,
    required this.phone,
    required this.brief,
    this.updatedAt = 0,
  });

  /// JSON 序列化
  factory UserBBSModel.fromJson(Map<String, dynamic> json) =>
      _$UserBBSModelFromJson(json);

  /// from sql json
  factory UserBBSModel.fromSqlJson(Map<String, dynamic> json) {
    var cookie = jsonDecode(json['cookie']);
    var brief = jsonDecode(json['brief']);
    return UserBBSModel(
      id: json['id'],
      uid: json['uid'],
      cookie: UserBBSModelCookie.fromJson(cookie),
      phone: json['phone'],
      brief: UserBBSModelBrief.fromJson(brief),
      updatedAt: json['updated_at'],
    );
  }

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$UserBBSModelToJson(this);

  /// to sql json
  Map<String, dynamic> toSqlJson() {
    return {
      'id': id,
      'uid': uid,
      'cookie': jsonEncode(cookie),
      'phone': phone,
      'brief': jsonEncode(brief),
      'updated_at': updatedAt,
    };
  }
}

/// 用户cookie信息
@JsonSerializable()
class UserBBSModelCookie {
  /// account_id
  @JsonKey(name: 'account_id')
  final String accountId;

  /// cookie_token
  @JsonKey(name: 'cookie_token')
  final String cookieToken;

  /// ltoken
  @JsonKey(name: 'ltoken')
  final String ltoken;

  /// ltuid
  @JsonKey(name: 'ltuid')
  final String ltuid;

  /// mid
  @JsonKey(name: 'mid')
  final String mid;

  /// stoken(v2)
  @JsonKey(name: 'stoken')
  final String stoken;

  /// stuid
  @JsonKey(name: 'stuid')
  final String stuid;

  /// 构造函数
  UserBBSModelCookie({
    required this.accountId,
    required this.cookieToken,
    required this.ltoken,
    required this.ltuid,
    required this.mid,
    required this.stoken,
    required this.stuid,
  });

  /// JSON 序列化
  factory UserBBSModelCookie.fromJson(Map<String, dynamic> json) =>
      _$UserBBSModelCookieFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$UserBBSModelCookieToJson(this);
}

/// 用户简略信息
@JsonSerializable()
class UserBBSModelBrief {
  /// 用户ID
  @JsonKey(name: 'uid')
  final String uid;

  /// 用户名
  @JsonKey(name: 'username')
  final String username;

  /// 用户头像
  @JsonKey(name: 'avatar')
  final String avatar;

  /// 用户签名
  @JsonKey(name: 'sign')
  final String sign;

  /// 构造函数
  UserBBSModelBrief({
    required this.uid,
    required this.username,
    required this.avatar,
    required this.sign,
  });

  /// JSON 序列化
  factory UserBBSModelBrief.fromJson(Map<String, dynamic> json) =>
      _$UserBBSModelBriefFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$UserBBSModelBriefToJson(this);
}
