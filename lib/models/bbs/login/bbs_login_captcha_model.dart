// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../bbs_base_model.dart';

/// 米社登录返回相应的模型
part 'bbs_login_captcha_model.g.dart';

/// 获取验证码返回
@JsonSerializable(explicitToJson: true)
class BbsLoginCaptchaResp extends BBSResp<BbsLoginCaptchaData> {
  /// constructor
  BbsLoginCaptchaResp({
    required super.retcode,
    required super.message,
    required BbsLoginCaptchaData super.data,
  });

  /// from json
  factory BbsLoginCaptchaResp.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginCaptchaRespFromJson(json);
}

/// 获取验证码返回的数据
@JsonSerializable()
class BbsLoginCaptchaData {
  /// sent_new
  @JsonKey(name: 'sent_new')
  String sentNew;

  /// countdown
  @JsonKey(name: 'countdown')
  String countdown;

  /// action_type
  @JsonKey(name: 'action_type')
  String actionType;

  /// constructor
  BbsLoginCaptchaData({
    required this.sentNew,
    required this.countdown,
    required this.actionType,
  });

  /// from json
  factory BbsLoginCaptchaData.fromJson(Map<String, dynamic> json) =>
      _$BbsLoginCaptchaDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsLoginCaptchaDataToJson(this);
}
