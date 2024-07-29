// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../tools/log_tool.dart';
import '../sp_sqlite.dart';

/// 用户数据表
class SpsUserBBS {
  SpsUserBBS._();

  static final SpsUserBBS _instance = SpsUserBBS._();

  factory SpsUserBBS() => _instance;

  final SPSqlite sqlite = SPSqlite();

  final String _tableName = 'UserBBS';

  Future<void> preCheck() async {
    var check = await _instance.sqlite.isTableExist(_instance._tableName);
    if (!check) {
      await _instance.sqlite.db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          uid TEXT NOT NULL,
          cookie TEXT,
          phone TEXT,
          brief TEXT,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');
      SPLogTool.info('Create table $_tableName');
    }
  }

  /// 读取所有用户信息
  Future<List<UserBBSModel>> readAll() async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(_instance._tableName);
    return result.map(UserBBSModel.fromSqlJson).toList();
  }

  /// 读取指定uid的用户信息
  Future<UserBBSModel?> readUser(String uid) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    if (result.isEmpty) {
      return null;
    }
    return UserBBSModel.fromSqlJson(result.first);
  }

  /// 更新用户信息
  Future<void> writeUser(UserBBSModel user) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
    if (result.isEmpty) {
      await _instance.sqlite.db.insert(
        _instance._tableName,
        user.toSqlJson(),
      );
    } else {
      await _instance.sqlite.db.update(
        _instance._tableName,
        user.toSqlJson(),
        where: 'uid = ?',
        whereArgs: [user.uid],
      );
    }
  }
}
