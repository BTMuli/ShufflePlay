// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/nap/nap_item_map.dart';
import '../../models/database/nap/nap_item_map_model.dart';
import '../../models/plugins/Hakushi/hakushi_model.dart';
import '../../tools/log_tool.dart';
import '../core/client.dart';

class SprPluginHakushi {
  /// 数据库
  final SpsNapItemMap sqlite = SpsNapItemMap();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://api.hakush.in/zzz/data/';

  /// 构造函数
  SprPluginHakushi() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 更新角色信息
  Future<void> freshCharacter() async {
    try {
      var resp = await client.dio.get('character.json');
      var data = resp.data as Map<String, dynamic>;
      for (var key in data.keys) {
        var item = data[key];
        var hakushiC = HakushiModelCharacter.fromJson(item);
        if (hakushiC.code.startsWith("Avatar_") || hakushiC.rank == null) {
          continue;
        }
        var napItem = NapItemMapModel.fromHakushiCharacter(key, hakushiC);
        await sqlite.write(napItem);
      }
    } on DioException catch (e) {
      SPLogTool.error('[DioException] Fail to fresh character ${e.message}');
    } on Exception catch (e) {
      SPLogTool.error('[Exception] Fail to fresh character ${e.toString()}');
    }
  }

  /// 更新武器信息
  Future<void> freshWeapon() async {
    try {
      var resp = await client.dio.get('weapon.json');
      var data = resp.data as Map<String, dynamic>;
      for (var key in data.keys) {
        var item = data[key];
        var hakushiW = HakushiModelWeapon.fromJson(item);
        var napItem = NapItemMapModel.fromHakushiWeapon(key, hakushiW);
        await sqlite.write(napItem);
      }
    } on DioException catch (e) {
      SPLogTool.error('[DioException] Fail to fresh weapon ${e.message}');
    } on Exception catch (e) {
      SPLogTool.error('[Exception] Fail to fresh weapon ${e.toString()}');
    }
  }

  /// 更新邦布信息
  Future<void> freshBangboo() async {
    try {
      var resp = await client.dio.get('bangboo.json');
      var data = resp.data as Map<String, dynamic>;
      for (var key in data.keys) {
        var item = data[key];
        var hakushiB = HakushiModelBangboo.fromJson(item);
        var napItem = NapItemMapModel.fromHakushiBangboo(key, hakushiB);
        await sqlite.write(napItem);
      }
    } on DioException catch (e) {
      SPLogTool.error('[DioException] Fail to fresh bond ${e.message}');
    } on Exception catch (e) {
      SPLogTool.error('[Exception] Fail to fresh bond ${e.toString()}');
    }
  }
}
