// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../bbs/bbs_base_model.dart';

/// 获取authkey返回
part 'nap_authkey_model.g.dart';

/// 获取authkey返回
@JsonSerializable(explicitToJson: true)
class NapAuthkeyModelResp extends BBSResp<NapAuthkeyModelData> {
  NapAuthkeyModelResp({
    required super.retcode,
    required super.message,
    required NapAuthkeyModelData super.data,
  });

  factory NapAuthkeyModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAuthkeyModelRespFromJson(json);
}

/// 获取authkey返回data
@JsonSerializable()
class NapAuthkeyModelData {
  /// sign_type
  @JsonKey(name: 'sign_type')
  final int signType;

  /// authkey_ver
  @JsonKey(name: 'authkey_ver')
  final int authkeyVer;

  /// authkey
  @JsonKey(name: 'authkey')
  final String authkey;

  /// constructor
  NapAuthkeyModelData({
    required this.signType,
    required this.authkeyVer,
    required this.authkey,
  });

  /// fromJson
  factory NapAuthkeyModelData.fromJson(Map<String, dynamic> json) =>
      _$NapAuthkeyModelDataFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$NapAuthkeyModelDataToJson(this);
}
