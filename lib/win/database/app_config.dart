// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../shared/database/app_config.dart';
import '../../shared/tools/log_tool.dart';

/// 应用配置
class SpsAppConfigWin extends SpsAppConfig {
  SpsAppConfigWin._();

  static final SpsAppConfigWin instance = SpsAppConfigWin._();

  factory SpsAppConfigWin() => instance;

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
    var defaultValue = Colors.blue.toAccentColor();
    if (res == null || res.isEmpty) {
      await writeAccentColor(defaultValue);
      return defaultValue;
    }
    var trans = int.tryParse(res);
    if (trans == null || trans.isNaN) {
      SPLogTool.warn('Invalid accent color: $res');
      await writeAccentColor(defaultValue);
      return defaultValue;
    }
    return Color(trans).toAccentColor();
  }

  /// 写/更新主题色配置
  Future<void> writeAccentColor(AccentColor value) async {
    await write('accentColor', value.value.toString());
  }

  /// 读取游戏安装目录
  Future<String> readGameDir() async {
    var res = await read('gameDir');
    if (res == null || res.isEmpty) {
      await writeGameDir('');
      return '';
    }
    return res;
  }

  /// 写/更新游戏安装目录
  Future<void> writeGameDir(String value) async {
    await write('gameDir', value);
  }
}
