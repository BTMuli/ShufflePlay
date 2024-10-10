// Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Project imports:
import '../../models/database/user/user_gacha_model.dart';
import '../../models/nap/gacha/nap_gacha_model.dart';
import '../../plugins/UIGF/models/uigf_enum.dart';
import '../../plugins/UIGF/models/uigf_model.dart';
import '../../utils/trans_time.dart';
import '../sp_sqlite.dart';

/// 用户祈愿数据表
class SpsUserGacha {
  SpsUserGacha._();

  static final SpsUserGacha _instance = SpsUserGacha._();

  factory SpsUserGacha() => _instance;

  final SPSqlite sqlite = SPSqlite();

  final String _tableName = 'UserGacha';

  Future<void> preCheck() async {
    var check = await _instance.sqlite.isTableExist(_instance._tableName);
    if (!check) {
      await _instance.sqlite.db.execute('''
      CREATE TABLE $_tableName (
        uid TEXT NOT NULL,
        gacha_id TEXT,
        gacha_type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        count TEXT,
        time TEXT NOT NULL,
        name TEXT,
        item_type TEXT,
        rank_type TEXT,
        id TEXT NOT NULL,
        PRIMARY KEY (uid, gacha_type, item_id, time)
      );
      ''');
    }
  }

  /// 获取所有不重复的uid
  Future<List<String>> getAllUid({bool check = false}) async {
    if (check) await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      columns: ['uid'],
      distinct: true,
    );
    return result.map((e) => e['uid'] as String).toList();
  }

  /// 获取指定[uid]的祈愿记录，如果没有指定[gachaType]则返回所有祈愿记录
  Future<List<UserGachaModel>> readUser(
    String uid, {
    UigfNapPoolType? gachaType,
  }) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ? ${gachaType == null ? '' : 'AND gacha_type = ?'}',
      whereArgs: [uid, if (gachaType != null) gachaType.value],
      orderBy: 'time DESC',
    );
    return result.map(UserGachaModel.fromSqlJson).toList();
  }

  /// 获取指定[uid]的祈愿记录，并转换为 UIGF 格式
  /// 将数据库的utc时间转换为指定时区[timezone]的时间
  Future<UigfModelNap> getUigfGacha(String uid, {int timezone = 0}) async {
    var dbRes = await _instance.sqlite.db.query(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
    var gachaList = dbRes.map(UserGachaModel.fromSqlJson).toList();
    var napList = <UigfModelNapItem>[];
    for (var item in gachaList) {
      var uigfItem = UigfModelNapItem(
        gachaId: item.gachaId,
        gachaType: item.gachaType,
        itemId: item.itemId,
        count: item.count,
        time: fromUtcTime(timezone, item.time),
        name: item.name,
        itemType: item.itemType,
        rankType: item.rankType,
        id: item.id,
      );
      napList.add(uigfItem);
    }
    return UigfModelNap(
      uid: uid,
      timezone: timezone,
      list: napList,
      lang: UigfLanguage.zhHans,
    );
  }

  /// 获取指定[uid]指定卡池[gachaType]的最新一条祈愿记录的id
  Future<UserGachaRefreshModel> getLatestGacha(
    String uid,
    UigfNapPoolType gachaType,
  ) async {
    await _instance.preCheck();
    var result = await _instance.sqlite.db.query(
      _instance._tableName,
      columns: ['id'],
      where: 'uid = ? AND gacha_type = ?',
      whereArgs: [uid, gachaType.value],
      orderBy: 'id DESC',
      limit: 1,
    );
    var res = UserGachaRefreshModel(gachaType);
    if (result.isEmpty) {
      return res;
    } else {
      res.id = result.first['id'] as String;
      return res;
    }
  }

  /// 导入祈愿记录-通过 UIGF 数据
  Future<void> importUigf(UigfModelFull uigf) async {
    await _instance.preCheck();
    var batch = _instance.sqlite.db.batch();
    for (var user in uigf.nap) {
      for (var item in user.list) {
        batch.insert(
          _instance._tableName,
          UserGachaModel(
            uid: user.uid.toString(),
            gachaType: item.gachaType,
            itemId: item.itemId,
            time: toUtcTime(user.timezone, item.time),
            id: item.id,
            name: item.name,
            count: item.count,
            itemType: item.itemType,
            rankType: item.rankType,
            gachaId: item.gachaId,
          ).toSqlJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    await batch.commit(noResult: true);
  }

  /// 删除指定[uid]的祈愿记录
  Future<void> deleteUser(String uid) async {
    await _instance.preCheck();
    await _instance.sqlite.db.delete(
      _instance._tableName,
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  /// 获取导出UIGF的头部信息
  Future<UigfModelInfo> getUigfInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return UigfModelInfo(
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      app: "ShufflePlay",
      appVersion: packageInfo.version,
      version: uigfVersion,
    );
  }

  /// 导出指定uid列表[uids]的祈愿记录-UIGF格式，如果没有指定uid则导出所有
  Future<UigfModelFull> exportUigf({List<String>? uids, int? timezone}) async {
    await _instance.preCheck();
    var uigfData = UigfModelFull(
      info: await getUigfInfo(),
      nap: [],
    );
    var uidList = uids ?? await getAllUid(check: true);
    var realTimezone = timezone ?? DateTime.now().timeZoneOffset.inHours;
    for (var uid in uidList) {
      var userGacha = await getUigfGacha(uid, timezone: realTimezone);
      uigfData.nap.add(userGacha);
    }
    return uigfData;
  }

  /// 导入祈愿记录-单项
  Future<void> importGacha(UserGachaModel item, {bool check = false}) async {
    if (check) await _instance.preCheck();
    await _instance.sqlite.db.insert(
      _instance._tableName,
      item.toSqlJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> importNapGacha(String gameUid, List<NapGachaModel> list) async {
    var localTimezone = DateTime.now().timeZoneOffset.inHours;
    for (var item in list) {
      var userGacha = UserGachaModel(
        uid: gameUid,
        gachaId: item.gachaId,
        gachaType: item.gachaType,
        itemId: item.itemId,
        count: item.count,
        time: toUtcTime(localTimezone, item.time),
        name: item.name,
        itemType: item.itemType,
        rankType: item.rankType,
        id: item.id,
      );
      await importGacha(userGacha);
    }
  }
}
