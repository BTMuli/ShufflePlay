// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../bbs_base_model.dart';

/// 米社设备信息相关的数据结构
part 'bbs_device_model.g.dart';

/// 获取设备指纹返回
@JsonSerializable(explicitToJson: true)
class BbsDeviceModelResp extends BBSResp<BbsDeviceModelData> {
  /// constructor
  BbsDeviceModelResp({
    required super.retcode,
    required super.message,
    required BbsDeviceModelData super.data,
  });

  /// from json
  factory BbsDeviceModelResp.fromJson(Map<String, dynamic> json) =>
      _$BbsDeviceModelRespFromJson(json);
}

/// 设备指纹数据
@JsonSerializable()
class BbsDeviceModelData {
  /// device_fp
  @JsonKey(name: 'device_fp')
  String deviceFp;

  /// code
  @JsonKey(name: 'code')
  int code;

  /// message
  @JsonKey(name: 'msg')
  String message;

  /// constructor
  BbsDeviceModelData({
    required this.deviceFp,
    required this.code,
    required this.message,
  });

  /// from json
  factory BbsDeviceModelData.fromJson(Map<String, dynamic> json) =>
      _$BbsDeviceModelDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsDeviceModelDataToJson(this);
}
