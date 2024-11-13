// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import '../../models/database/app/app_config_model.dart';
import '../tools/log_tool.dart';
import '../utils/gen_random_str.dart';
import 'sp_sqlite.dart';

/// 应用配置-可继承
class SpsAppConfig {
  SpsAppConfig();

  final SPSqlite sqlite = SPSqlite();
  final String tableName = 'AppConfig';

  /// 前置检查
  Future<void> preCheck() async {
    var check = await sqlite.isTableExist(tableName);
    if (!check) {
      await sqlite.db.execute('''
        CREATE TABLE $tableName (
          key TEXT NOT NULL PRIMARY KEY,
          value TEXT NOT NULL
        );
      ''');
      SPLogTool.info('Create table $tableName');
    }
  }

  /// 读取配置
  Future<String?> read(String key) async {
    await preCheck();
    var result = await sqlite.db.query(
      tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return '';
    var value = result.first['value'];
    SPLogTool.info('Read config: $key = $value');
    return value.toString();
  }

  /// 写入/更新配置
  Future<void> write(String key, String value) async {
    await preCheck();
    var result = await sqlite.db.query(
      tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) {
      await sqlite.db.insert(
        tableName,
        {'key': key, 'value': value},
      );
      SPLogTool.info('Write config: $key = $value');
    } else {
      await sqlite.db.update(
        tableName,
        {'value': value},
        where: 'key = ?',
        whereArgs: [key],
      );
    }
    SPLogTool.info('Update config: $key = $value');
  }

  /// 删除配置
  Future<void> delete(String key) async {
    await preCheck();
    await sqlite.db.delete(
      tableName,
      where: 'key = ?',
      whereArgs: [key],
    );
    SPLogTool.info('Delete config: $key');
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
    var res = await read('device');
    if (res == null || res.isEmpty) {
      var device = genDefaultDevice();
      await writeDevice(device);
      return device;
    }
    return AppConfigModelDevice.fromJson(jsonDecode(res));
  }

  /// 写/更新设备信息
  Future<void> writeDevice(AppConfigModelDevice value) async {
    await write('device', jsonEncode(value));
  }
}
