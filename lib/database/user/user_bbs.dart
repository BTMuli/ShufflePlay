// Package imports:
import 'package:jiffy/jiffy.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../tools/log_tool.dart';
import '../sp_sqlite.dart';
import 'user_nap.dart';

/// 用户数据表
class SpsUserBbs {
  SpsUserBbs._();

  static final SpsUserBbs _instance = SpsUserBbs._();

  factory SpsUserBbs() => _instance;

  final SPSqlite sqlite = SPSqlite();

  final SpsUserNap sqliteNap = SpsUserNap();

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
  Future<List<UserBBSModel>> readAllUsers() async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(_instance._tableName);
    return result.map(UserBBSModel.fromSqlJson).toList();
  }

  /// 读取所有uid
  Future<List<String>> readAllUids() async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      columns: ['uid'],
      distinct: true,
    );
    return result.map((e) => e['uid'].toString()).toList();
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
    user.updatedAt = Jiffy.now().second;
    if (result.isEmpty) {
      await _instance.sqlite.db.insert(
        _instance._tableName,
        user.toSqlJson(),
      );
    } else {
      user.id = result.first['id'] as int?;
      await _instance.sqlite.db.update(
        _instance._tableName,
        user.toSqlJson(),
        where: 'uid = ?',
        whereArgs: [user.uid],
      );
    }
  }

  /// 删除用户信息
  Future<void> deleteUser(String uid) async {
    await _instance.preCheck();
    await _instance.sqlite.db.delete(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    await _instance.sqliteNap.deleteUser(uid);
  }
}
