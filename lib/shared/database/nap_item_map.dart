// Project imports:
import '../../models/database/nap/nap_item_map_model.dart';
import '../tools/log_tool.dart';
import 'sp_sqlite.dart';

/// item_id 与对应信息的映射表
class SpsNapItemMap {
  SpsNapItemMap._();

  /// 实例
  static final SpsNapItemMap _instance = SpsNapItemMap._();

  /// 获取实例
  factory SpsNapItemMap() => _instance;

  /// 数据库
  final SPSqlite sqlite = SPSqlite();

  /// 表名
  final String _tableName = 'NapItemMap';

  /// 前置检查
  Future<void> preCheck() async {
    var check = await _instance.sqlite.isTableExist(_tableName);
    if (!check) {
      await _instance.sqlite.db.execute('''
        CREATE TABLE $_tableName (
          item_id TEXT NOT NULL PRIMARY KEY,
          rank TEXT NOT NULL,
          type TEXT NOT NULL,
          locale TEXT NOT NULL
        );
      ''');
      SPLogTool.info('Create table $_tableName');
    }
  }

  /// 读取指定 item_id 的信息
  Future<NapItemMapModel?> read(String key, {bool check = false}) async {
    if (check) await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _tableName,
      where: 'item_id = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    var value = result.first;
    return NapItemMapModel.fromSqlJson(value);
  }

  /// 写入/更新指定 item_id 的信息
  Future<void> write(NapItemMapModel model, {bool check = false}) async {
    if (check) await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _tableName,
      where: 'item_id = ?',
      whereArgs: [model.itemId],
    );
    if (result.isEmpty) {
      await _instance.sqlite.db.insert(_tableName, model.toSqlJson());
      return;
    }
    await _instance.sqlite.db.update(
      _tableName,
      model.toSqlJson(),
      where: 'item_id = ?',
      whereArgs: [model.itemId],
    );
  }
}
