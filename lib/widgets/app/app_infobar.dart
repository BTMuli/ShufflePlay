// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/app/app_enum.dart';

/// 对SnackBar的封装
class SpInfobar {
  SpInfobar._();

  /// 实例
  static final SpInfobar _instance = SpInfobar._();

  /// 获取实例
  factory SpInfobar() => _instance;

  /// show
  static void show(
    BuildContext context,
    String text,
    AppInfoSeverity severity,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: severity.color,
      ),
    );
  }

  /// info
  static void info(BuildContext context, String text) {
    show(context, text, AppInfoSeverity.info);
  }

  /// success
  static void success(BuildContext context, String text) {
    show(context, text, AppInfoSeverity.success);
  }

  /// warning
  static void warning(BuildContext context, String text) {
    show(context, text, AppInfoSeverity.warning);
  }

  /// error
  static void error(BuildContext context, String text) {
    show(context, text, AppInfoSeverity.error);
  }
}
