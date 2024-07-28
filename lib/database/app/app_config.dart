// Project imports:
import '../../tools/log_tool.dart';
import '../sp_sqlite.dart';

/// 应用配置
class BtsAppConfig {
  BtsAppConfig._();

  /// 实例
  static final BtsAppConfig _instance = BtsAppConfig._();

  /// 获取实例
  factory BtsAppConfig() => _instance;

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

  /// 读取字体配置
}
