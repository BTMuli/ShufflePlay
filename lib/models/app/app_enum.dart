// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// 应用中常见的枚举

/// 消息类型
@JsonEnum(valueField: 'value')
enum AppInfoSeverity {
  /// 信息
  info('info'),

  /// 成功
  success('success'),

  /// 警告
  warning('warning'),

  /// 错误
  error('error');

  /// value
  final String value;

  const AppInfoSeverity(this.value);
}

extension AppInfoSeverityExtension on AppInfoSeverity {
  Color get color {
    switch (this) {
      case AppInfoSeverity.info:
        return Colors.blue;
      case AppInfoSeverity.success:
        return Colors.green;
      case AppInfoSeverity.warning:
        return Colors.orange;
      case AppInfoSeverity.error:
        return Colors.red;
    }
  }
}
