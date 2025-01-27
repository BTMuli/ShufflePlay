import "package:json_annotation/json_annotation.dart";

import '../bbs_base_model.dart';

part 'bbs_login_qr_model.g.dart';

/// 米社扫码获取二维码返回的模型
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsLoginQrGetQrResp extends BBSResp<BbsLoginQrGetQrData> {
  /// constructor
  BbsLoginQrGetQrResp({
    required super.retcode,
    required super.message,
    required BbsLoginQrGetQrData data,
  }) : super(data: data);

  /// from json
  factory BbsLoginQrGetQrResp.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrGetQrRespFromJson(json);
}

/// 米社扫码登录返回的数据
@JsonSerializable()
class BbsLoginQrGetQrData {
  /// ticket
  @JsonKey(name: 'ticket')
  String ticket;

  /// url
  @JsonKey(name: 'url')
  String url;

  /// constructor
  BbsLoginQrGetQrData({required this.ticket, required this.url});

  /// from json
  factory BbsLoginQrGetQrData.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrGetQrDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsLoginQrGetQrDataToJson(this);
}

/// 登录状态返回
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsLoginQrStatResp extends BBSResp<BbsLoginQrStatData> {
  /// constructor
  BbsLoginQrStatResp({
    required super.retcode,
    required super.message,
    required BbsLoginQrStatData data,
  }) : super(data: data);

  /// from json
  factory BbsLoginQrStatResp.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrStatRespFromJson(json);
}

/// 登录状态返回的数据
@JsonSerializable()
class BbsLoginQrStatData {
  /// app_id
  @JsonKey(name: 'app_id')
  String appId;

  /// client_type
  @JsonKey(name: 'client_type')
  int clientType;

  /// created_at
  @JsonKey(name: 'created_at')
  String createdAt;

  /// ext
  @JsonKey(name: 'ext')
  String ext;

  /// need_realperson
  @JsonKey(name: 'need_realperson')
  bool needRealperson;

  /// realname_info
  @JsonKey(name: 'realname_info')
  dynamic realnameInfo;

  /// scan_game_biz
  @JsonKey(name: 'scan_game_biz')
  String scanGameBiz;

  /// scanned_at
  @JsonKey(name: 'scanned_at')
  String scannedAt;

  /// status
  @JsonKey(name: 'status')
  String status;

  /// tokens
  @JsonKey(name: 'tokens')
  List<BbsLoginQrStatDataToken> tokens;

  /// user_info
  @JsonKey(name: 'user_info')
  BbsLoginQrStatDataUserInfo? userInfo;

  /// constructor
  BbsLoginQrStatData({
    required this.appId,
    required this.clientType,
    required this.createdAt,
    required this.ext,
    required this.needRealperson,
    required this.realnameInfo,
    required this.scanGameBiz,
    required this.scannedAt,
    required this.status,
    required this.tokens,
    required this.userInfo,
  });

  /// from json
  factory BbsLoginQrStatData.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrStatDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsLoginQrStatDataToJson(this);
}

/// 登录状态返回的数据中的tokens
@JsonSerializable()
class BbsLoginQrStatDataToken {
  /// token
  @JsonKey(name: 'token')
  String token;

  /// token_type
  @JsonKey(name: 'token_type')
  int tokenType;

  /// constructor
  BbsLoginQrStatDataToken({required this.token, required this.tokenType});

  /// from json
  factory BbsLoginQrStatDataToken.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrStatDataTokenFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsLoginQrStatDataTokenToJson(this);
}

/// 登录状态返回的数据中的user_info
@JsonSerializable()
class BbsLoginQrStatDataUserInfo {
  /// account_name
  @JsonKey(name: 'account_name')
  String accountName;

  /// aid
  @JsonKey(name: 'aid')
  String aid;

  /// area_code
  @JsonKey(name: 'area_code')
  String areaCode;

  /// country
  @JsonKey(name: 'country')
  String country;

  /// email
  @JsonKey(name: 'email')
  String email;

  /// identity_code
  @JsonKey(name: 'identity_code')
  String identityCode;

  /// is_email_verify
  @JsonKey(name: 'is_email_verify')
  int isEmailVerify;

  /// links
  @JsonKey(name: 'links')
  List<dynamic> links;

  /// mid
  @JsonKey(name: 'mid')
  String mid;

  /// mobile
  @JsonKey(name: 'mobile')
  String mobile;

  /// password_time
  @JsonKey(name: 'password_time')
  String passwordTime;

  /// realname
  @JsonKey(name: 'realname')
  String realName;

  /// rebind_area_code
  @JsonKey(name: 'rebind_area_code')
  String rebindAreaCode;

  /// rebind_mobile
  @JsonKey(name: 'rebind_mobile')
  String rebindMobile;

  /// rebind_mobile_time
  @JsonKey(name: 'rebind_mobile_time')
  String rebindMobileTime;

  /// safe_area_code
  @JsonKey(name: 'safe_area_code')
  String safeAreaCode;

  /// safe_mobile
  @JsonKey(name: 'safe_mobile')
  String safeMobile;

  /// unmasked_email
  @JsonKey(name: 'unmasked_email')
  String unmaskedEmail;

  /// unmasked_email_type
  @JsonKey(name: 'unmasked_email_type')
  int unmaskedEmailType;

  /// constructor
  BbsLoginQrStatDataUserInfo({
    required this.accountName,
    required this.aid,
    required this.areaCode,
    required this.country,
    required this.email,
    required this.identityCode,
    required this.isEmailVerify,
    required this.links,
    required this.mid,
    required this.mobile,
    required this.passwordTime,
    required this.realName,
    required this.rebindAreaCode,
    required this.rebindMobile,
    required this.rebindMobileTime,
    required this.safeAreaCode,
    required this.safeMobile,
    required this.unmaskedEmail,
    required this.unmaskedEmailType,
  });

  /// from json
  factory BbsLoginQrStatDataUserInfo.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginQrStatDataUserInfoFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsLoginQrStatDataUserInfoToJson(this);
}
