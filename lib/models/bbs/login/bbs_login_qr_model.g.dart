// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_login_qr_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsLoginQrGetQrResp _$BbsLoginQrGetQrRespFromJson(Map<String, dynamic> json) =>
    BbsLoginQrGetQrResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsLoginQrGetQrData.fromJson(json['data'] as Map<String, dynamic>),
    );

BbsLoginQrGetQrData _$BbsLoginQrGetQrDataFromJson(Map<String, dynamic> json) =>
    BbsLoginQrGetQrData(
      ticket: json['ticket'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$BbsLoginQrGetQrDataToJson(
        BbsLoginQrGetQrData instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
      'url': instance.url,
    };

BbsLoginQrStatResp _$BbsLoginQrStatRespFromJson(Map<String, dynamic> json) =>
    BbsLoginQrStatResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: BbsLoginQrStatData.fromJson(json['data'] as Map<String, dynamic>),
    );

BbsLoginQrStatData _$BbsLoginQrStatDataFromJson(Map<String, dynamic> json) =>
    BbsLoginQrStatData(
      appId: json['app_id'] as String,
      clientType: (json['client_type'] as num).toInt(),
      createdAt: json['created_at'] as String,
      ext: json['ext'] as String,
      needRealperson: json['need_realperson'] as bool,
      realnameInfo: json['realname_info'],
      scanGameBiz: json['scan_game_biz'] as String,
      scannedAt: json['scanned_at'] as String,
      status: json['status'] as String,
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) =>
              BbsLoginQrStatDataToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      userInfo: json['user_info'] == null
          ? null
          : BbsLoginQrStatDataUserInfo.fromJson(
              json['user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsLoginQrStatDataToJson(BbsLoginQrStatData instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'client_type': instance.clientType,
      'created_at': instance.createdAt,
      'ext': instance.ext,
      'need_realperson': instance.needRealperson,
      'realname_info': instance.realnameInfo,
      'scan_game_biz': instance.scanGameBiz,
      'scanned_at': instance.scannedAt,
      'status': instance.status,
      'tokens': instance.tokens,
      'user_info': instance.userInfo,
    };

BbsLoginQrStatDataToken _$BbsLoginQrStatDataTokenFromJson(
        Map<String, dynamic> json) =>
    BbsLoginQrStatDataToken(
      token: json['token'] as String,
      tokenType: (json['token_type'] as num).toInt(),
    );

Map<String, dynamic> _$BbsLoginQrStatDataTokenToJson(
        BbsLoginQrStatDataToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'token_type': instance.tokenType,
    };

BbsLoginQrStatDataUserInfo _$BbsLoginQrStatDataUserInfoFromJson(
        Map<String, dynamic> json) =>
    BbsLoginQrStatDataUserInfo(
      accountName: json['account_name'] as String,
      aid: json['aid'] as String,
      areaCode: json['area_code'] as String,
      country: json['country'] as String,
      email: json['email'] as String,
      identityCode: json['identity_code'] as String,
      isEmailVerify: (json['is_email_verify'] as num).toInt(),
      links: json['links'] as List<dynamic>,
      mid: json['mid'] as String,
      mobile: json['mobile'] as String,
      passwordTime: json['password_time'] as String,
      realName: json['realname'] as String,
      rebindAreaCode: json['rebind_area_code'] as String,
      rebindMobile: json['rebind_mobile'] as String,
      rebindMobileTime: json['rebind_mobile_time'] as String,
      safeAreaCode: json['safe_area_code'] as String,
      safeMobile: json['safe_mobile'] as String,
      unmaskedEmail: json['unmasked_email'] as String,
      unmaskedEmailType: (json['unmasked_email_type'] as num).toInt(),
    );

Map<String, dynamic> _$BbsLoginQrStatDataUserInfoToJson(
        BbsLoginQrStatDataUserInfo instance) =>
    <String, dynamic>{
      'account_name': instance.accountName,
      'aid': instance.aid,
      'area_code': instance.areaCode,
      'country': instance.country,
      'email': instance.email,
      'identity_code': instance.identityCode,
      'is_email_verify': instance.isEmailVerify,
      'links': instance.links,
      'mid': instance.mid,
      'mobile': instance.mobile,
      'password_time': instance.passwordTime,
      'realname': instance.realName,
      'rebind_area_code': instance.rebindAreaCode,
      'rebind_mobile': instance.rebindMobile,
      'rebind_mobile_time': instance.rebindMobileTime,
      'safe_area_code': instance.safeAreaCode,
      'safe_mobile': instance.safeMobile,
      'unmasked_email': instance.unmaskedEmail,
      'unmasked_email_type': instance.unmaskedEmailType,
    };
