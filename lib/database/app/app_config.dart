// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../../models/database/app/app_config_model.dart';
import '../../tools/log_tool.dart';
import '../../utils/gen_random_str.dart';
import '../sp_sqlite.dart';

/// 应用配置
class SpsAppConfig {
  SpsAppConfig._();

  /// 实例
  static final SpsAppConfig _instance = SpsAppConfig._();

  /// 获取实例
  factory SpsAppConfig() => _instance;

  /// 数据库
  final SPSqlite sqlite = SPSqlite();

  /// 表名
  final String _tableName = 'AppConfig';

  /// 前置检查-通用
  Future<void> preCheck() async {
    var check = await _instance.sqlite.isTableExist(_instance._tableName);
    if (!check) {
      await _instance.sqlite.db.execute('''
        CREATE TABLE $_tableName (
          key TEXT NOT NULL PRIMARY KEY,
          value TEXT NOT NULL
        );
      ''');
      SPLogTool.info('Create table $_tableName');
    }
  }

  /// 读取配置-通用
  Future<String?> read(String key) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return '';
    var value = result.first['value'];
    SPLogTool.info('Read config: $key = $value');
    return value.toString();
  }

  /// 写入/更新配置-通用
  Future<void> write(String key, String value) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) {
      await _instance.sqlite.db.insert(
        _tableName,
        {'key': key, 'value': value},
      );
      SPLogTool.info('Write config: $key = $value');
    } else {
      await _instance.sqlite.db.update(
        _tableName,
        {'value': value},
        where: 'key = ?',
        whereArgs: [key],
      );
    }
    SPLogTool.info('Update config: $key = $value');
  }

  /// 删除配置-通用
  Future<void> delete(String key) async {
    await _instance.preCheck();
    await _instance.sqlite.db.delete(
      _tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    SPLogTool.info('Delete config: $key');
  }

  /// 读取主题模式配置
  Future<ThemeMode> readThemeMode() async {
    var res = await _instance.read('themeMode');
    var defaultValue = ThemeMode.system;
    if (res == null || res.isEmpty) {
      await _instance.writeThemeMode(defaultValue);
      return defaultValue;
    }
    const allowList = ["ThemeMode.system", "ThemeMode.light", "ThemeMode.dark"];
    if (!allowList.contains(res)) {
      SPLogTool.warn('Invalid theme mode: $res');
      await _instance.writeThemeMode(defaultValue);
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
    await _instance.write('themeMode', value.toString());
  }

  /// 读取主题色配置
  Future<AccentColor> readAccentColor() async {
    var res = await _instance.read('accentColor');
    var defaultValue = Colors.blue.toAccentColor();
    if (res == null || res.isEmpty) {
      await _instance.writeAccentColor(defaultValue);
      return defaultValue;
    }
    var trans = int.tryParse(res);
    if (trans == null || trans.isNaN) {
      SPLogTool.warn('Invalid accent color: $res');
      await _instance.writeAccentColor(defaultValue);
      return defaultValue;
    }
    return Color(trans).toAccentColor();
  }

  /// 写/更新主题色配置
  Future<void> writeAccentColor(AccentColor value) async {
    await _instance.write('accentColor', value.value.toString());
  }

  /// 生成默认设备信息
  AppConfigModelDevice genDefaultDevice() {
    return AppConfigModelDevice(
      deviceId: const Uuid().v4(),
      deviceFp: "0" * 13,
      deviceName: genRandomStr(12, type: RandomStringType.upper),
      model: genRandomStr(6, type: RandomStringType.upper),
      seedId: const Uuid().v4(),
      seedTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// 读取设备信息
  Future<AppConfigModelDevice> readDevice() async {
    var res = await _instance.read('device');
    if (res == null || res.isEmpty) {
      var device = genDefaultDevice();
      await _instance.writeDevice(device);
      return device;
    }
    return AppConfigModelDevice.fromJson(jsonDecode(res));
  }

  /// 写/更新设备信息
  Future<void> writeDevice(AppConfigModelDevice value) async {
    await _instance.write('device', jsonEncode(value));
  }
}
