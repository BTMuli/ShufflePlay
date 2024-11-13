// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import '../../../shared/database/app_config.dart';
import '../../../shared/tools/log_tool.dart';

/// 应用配置
class SpsAppConfigMac extends SpsAppConfig {
  SpsAppConfigMac._();

  static final SpsAppConfigMac instance = SpsAppConfigMac._();

  factory SpsAppConfigMac() => instance;

  /// 读取主题模式配置
  Future<ThemeMode> readThemeMode() async {
    var res = await read('themeMode');
    var defaultValue = ThemeMode.system;
    if (res == null || res.isEmpty) {
      await writeThemeMode(defaultValue);
      return defaultValue;
    }
    const allowList = ["ThemeMode.system", "ThemeMode.light", "ThemeMode.dark"];
    if (!allowList.contains(res)) {
      SPLogTool.warn('Invalid theme mode: $res');
      await writeThemeMode(defaultValue);
      return defaultValue;
    }
    switch (res) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
    }
    return defaultValue;
  }

  /// 写/更新主题模式配置
  Future<void> writeThemeMode(ThemeMode value) async {
    await write('themeMode', value.toString());
  }

  /// 读取主题色配置
  Future<AccentColor> readAccentColor() async {
    var res = await read('accentColor');
    var defaultValue = AccentColor.blue;
    if (res == null || res.isEmpty) {
      await writeAccentColor(defaultValue);
      return defaultValue;
    }
    switch (res) {
      case 'blue':
        return AccentColor.blue;
      case 'purple':
        return AccentColor.purple;
      case 'pink':
        return AccentColor.pink;
      case 'red':
        return AccentColor.red;
      case 'orange':
        return AccentColor.orange;
      case 'yellow':
        return AccentColor.yellow;
      case 'green':
        return AccentColor.green;
      case 'graphite':
        return AccentColor.graphite;
      default:
        return AccentColor.blue;
    }
  }

  /// 写/更新主题色配置
  Future<void> writeAccentColor(AccentColor value) async {
    await write('accentColor', value.name);
  }
}
