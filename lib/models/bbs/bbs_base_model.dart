// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// 米游社相关的基本模型
part 'bbs_base_model.g.dart';

/// 基本请求返回数据
@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BBSResp<T> {
  /// retcode
  @JsonKey(name: 'retcode')
  int retcode;

  /// message
  @JsonKey(name: 'message')
  String message;

  /// data
  T? data;

  /// constructor
  BBSResp({
    required this.retcode,
    required this.message,
    required this.data,
  });

  /// from json
  factory BBSResp.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$BBSRespFromJson(json, fromJsonT);

  /// to json
  Map<String, dynamic> toJson(dynamic Function(T value) toJsonT) =>
      _$BBSRespToJson(this, toJsonT);

  /// error
  static BBSResp<T> error<T>({
    required int retcode,
    required String message,
    T? data,
  }) =>
      BBSResp(retcode: retcode, message: message, data: data);
}
