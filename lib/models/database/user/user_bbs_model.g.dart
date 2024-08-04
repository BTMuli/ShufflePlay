// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bbs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBBSModel _$UserBBSModelFromJson(Map<String, dynamic> json) => UserBBSModel(
      id: (json['id'] as num?)?.toInt(),
      uid: json['uid'] as String,
      cookie: json['cookie'] == null
          ? null
          : UserBBSModelCookie.fromJson(json['cookie'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      brief: json['brief'] == null
          ? null
          : UserBBSModelBrief.fromJson(json['brief'] as Map<String, dynamic>),
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserBBSModelToJson(UserBBSModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'cookie': instance.cookie?.toJson(),
      'phone': instance.phone,
      'brief': instance.brief?.toJson(),
      'updatedAt': instance.updatedAt,
    };

UserBBSModelCookie _$UserBBSModelCookieFromJson(Map<String, dynamic> json) =>
    UserBBSModelCookie(
      accountId: json['account_id'] as String?,
      cookieToken: json['cookie_token'] as String?,
      ltoken: json['ltoken'] as String?,
      ltuid: json['ltuid'] as String?,
      mid: json['mid'] as String,
      stoken: json['stoken'] as String,
      stuid: json['stuid'] as String,
    );

Map<String, dynamic> _$UserBBSModelCookieToJson(UserBBSModelCookie instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'cookie_token': instance.cookieToken,
      'ltoken': instance.ltoken,
      'ltuid': instance.ltuid,
      'mid': instance.mid,
      'stoken': instance.stoken,
      'stuid': instance.stuid,
    };

UserBBSModelBrief _$UserBBSModelBriefFromJson(Map<String, dynamic> json) =>
    UserBBSModelBrief(
      uid: json['uid'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
      sign: json['sign'] as String,
    );

Map<String, dynamic> _$UserBBSModelBriefToJson(UserBBSModelBrief instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'avatar': instance.avatar,
      'sign': instance.sign,
    };
