// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// NapItemMap 表的数据类型枚举

/// 数据类型枚举
@JsonEnum(valueField: 'value')
enum NapItemMapType {
  /// 代理人
  character('character'),

  /// 音擎
  weapon('weapon'),

  /// 邦布
  bangboo('bangboo');

  /// value
  final String value;

  const NapItemMapType(this.value);
}

/// 翻译拓展
extension NapItemMapTypeExtension on NapItemMapType {
  String get zh {
    switch (this) {
      case NapItemMapType.character:
        return '代理人';
      case NapItemMapType.weapon:
        return '音擎';
      case NapItemMapType.bangboo:
        return '邦布';
    }
  }
}
