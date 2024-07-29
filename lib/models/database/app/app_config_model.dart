// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// AppConfig 表的数据模型
/// 该表在 lib/database/app/app_config.dart 中定义
part 'app_config_model.g.dart';

/// AppConfig 表的设备信息模型
@JsonSerializable()
class AppConfigModelDevice {
  /// 设备ID
  @JsonKey(name: 'device_id')
  final String deviceId;

  /// 设备指纹
  @JsonKey(name: 'device_fp')
  final String deviceFp;

  /// 设备名称
  @JsonKey(name: 'device_name')
  final String deviceName;

  /// 模型
  @JsonKey(name: 'model')
  final String model;

  /// 种子id
  @JsonKey(name: 'seed_id')
  final String seedId;

  /// 种子时间
  @JsonKey(name: 'seed_time')
  final String seedTime;

  /// 构造函数
  AppConfigModelDevice({
    required this.deviceId,
    required this.deviceFp,
    required this.deviceName,
    required this.model,
    required this.seedId,
    required this.seedTime,
  });

  /// JSON 序列化
  factory AppConfigModelDevice.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelDeviceFromJson(json);

  /// JSON 反序列化
  Map<String, dynamic> toJson() => _$AppConfigModelDeviceToJson(this);
}
