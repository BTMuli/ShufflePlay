// Project imports:
import '../../models/database/user/user_nap_model.dart';
import '../tools/log_tool.dart';
import 'sp_sqlite.dart';

/// 用户绝区零游戏账号表
class SpsUserNap {
  SpsUserNap._();

  static final SpsUserNap _instance = SpsUserNap._();

  factory SpsUserNap() => _instance;

  final SPSqlite sqlite = SPSqlite();

  final String _tableName = 'UserNap';

  Future<void> preCheck() async {
    var check = await _instance.sqlite.isTableExist(_instance._tableName);
    if (!check) {
      await _instance.sqlite.db.execute('''
        CREATE TABLE $_tableName (
          uid TEXT NOT NULL,
          game_biz TEXT NOT NULL,
          game_uid TEXT NOT NULL,
          is_chosen INTEGER NOT NULL,
          is_official INTEGER NOT NULL,
          level INTEGER NOT NULL,
          nickname TEXT NOT NULL,
          region TEXT NOT NULL,
          region_name TEXT NOT NULL,
          PRIMARY KEY (uid, game_biz, game_uid)
        );
      ''');
      SPLogTool.info('Create table $_tableName');
    }
  }

  /// 读取指定uid的用户绝区零游戏账号信息
  Future<List<UserNapModel>> readUser(String uid) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return result.map(UserNapModel.fromSqlJson).toList();
  }

  /// 删除指定uid的用户绝区零游戏账号信息
  Future<void> deleteUser(String uid) async {
    await _instance.preCheck();
    await _instance.sqlite.db.delete(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  /// 插入/更新用户绝区零游戏账号信息
  Future<void> insertUser(UserNapModel user) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ? AND game_biz = ? AND game_uid = ?',
      whereArgs: [user.uid, user.gameBiz, user.gameUid],
    );
    if (result.isEmpty) {
      await _instance.sqlite.db.insert(_instance._tableName, user.toSqlJson());
    } else {
      await _instance.sqlite.db.update(
        _instance._tableName,
        user.toSqlJson(),
        where: 'uid = ? AND game_biz = ? AND game_uid = ?',
        whereArgs: [user.uid, user.gameBiz, user.gameUid],
      );
    }
  }
}
