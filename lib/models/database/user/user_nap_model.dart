// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../nap/account/nap_account_model.dart';

/// 用户游戏账号表
/// 该表在 lib/database/user/user_nap.dart 中定义
part 'user_nap_model.g.dart';

/// 用户游戏账号表
@JsonSerializable()
class UserNapModel extends NapAccountModel {
  /// uid
  @JsonKey(name: 'uid')
  final String uid;

  /// constructor
  UserNapModel({
    required this.uid,
    required super.gameBiz,
    required super.gameUid,
    required super.isChosen,
    required super.isOfficial,
    required super.level,
    required super.nickname,
    required super.region,
    required super.regionName,
  });

  /// from json
  factory UserNapModel.fromJson(Map<String, dynamic> json) =>
      _$UserNapModelFromJson(json);

  /// from sql json
  factory UserNapModel.fromSqlJson(Map<String, dynamic> json) {
    return UserNapModel(
      uid: json['uid'] as String,
      gameBiz: json['game_biz'] as String,
      gameUid: json['game_uid'] as String,
      isChosen: jsonDecode(json['is_chosen']) as bool,
      isOfficial: jsonDecode(json['is_official']) as bool,
      level: json['level'] as int,
      nickname: json['nickname'] as String,
      region: json['region'] as String,
      regionName: json['region_name'] as String,
    );
  }

  /// to json
  @override
  Map<String, dynamic> toJson() => _$UserNapModelToJson(this);

  /// to sql json
  Map<String, dynamic> toSqlJson() {
    return {
      'uid': uid,
      'game_biz': gameBiz,
      'game_uid': gameUid,
      'is_chosen': jsonEncode(isChosen),
      'is_official': jsonEncode(isOfficial),
      'level': level,
      'nickname': nickname,
      'region': region,
      'region_name': regionName,
    };
  }
}
