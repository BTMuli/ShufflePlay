// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import '../../models/database/app/app_config_model.dart';
import '../database/app/app_config.dart';

/// 应用状态提供者
final appConfigStoreProvider = ChangeNotifierProvider<SpAppConfigStore>((ref) {
  return SpAppConfigStore();
});

/// 应用状态
class SpAppConfigStore extends ChangeNotifier {
  /// 应用配置数据库
  final SpsAppConfigMac sqlite = SpsAppConfigMac();

  /// 主题
  ThemeMode _themeMode = ThemeMode.system;

  /// 主题色
  AccentColor _accentColor = AccentColor.blue;

  /// 设备指纹
  AppConfigModelDevice? _device;

  /// 获取主题
  ThemeMode get themeMode => _themeMode;

  /// 获取设备信息
  AppConfigModelDevice? get device => _device;

  /// 构造函数
  SpAppConfigStore() {
    initThemeConfig();
    initAccentColorConfig();
    initAppDevice();
  }

  /// 初始化主题
  Future<void> initThemeConfig() async {
    _themeMode = await sqlite.readThemeMode();
    notifyListeners();
  }

  /// 初始化主题色
  Future<void> initAccentColorConfig() async {
    _accentColor = await sqlite.readAccentColor();
    notifyListeners();
  }

  /// 初始化设备信息
  Future<void> initAppDevice() async {
    _device = await sqlite.readDevice();
    notifyListeners();
  }

  /// 设置主题
  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    await sqlite.writeThemeMode(value);
    notifyListeners();
  }

  /// 获取主题色
  AccentColor get accentColor {
    if (_themeMode == ThemeMode.system) {
      return AccentColor.blue;
    } else {
      return _accentColor;
    }
  }

  /// 设置主题色
  Future<void> setAccentColor(AccentColor value) async {
    _accentColor = value;
    await sqlite.writeAccentColor(value);
    notifyListeners();
  }

  /// 设置设备信息
  Future<void> setDevice(AppConfigModelDevice value) async {
    _device = value;
    await sqlite.writeDevice(value);
    notifyListeners();
  }
}
