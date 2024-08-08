// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_base_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/gacha/nap_gacha_model.dart';
import '../../models/plugins/UIGF/uigf_enum.dart';
import '../core/client.dart';

class SprNapApiGacha {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://public-operation-nap.mihoyo.com/';

  /// 构造函数
  SprNapApiGacha() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取用户祈愿数据
  Future<BBSResp> getGachaLogs(
    UserNapModel account,
    UserBBSModelCookie ck,
    String authKey, {
    UigfNapPoolType gachaType = UigfNapPoolType.normal,
    String? endId,
    int page = 1,
  }) async {
    var params = {
      "lang": "zh-cn",
      "auth_appid": "webview_gacha",
      "authkey": authKey,
      "authkey_ver": "1",
      "sign_type": "2",
      "real_gacha_type": gachaType.value,
      "size": "20",
      "end_id": endId?.toString() ?? "",
      "region": account.region,
      "game_biz": account.gameBiz,
      "page": page.toString(),
    };
    try {
      var resp = await client.dio.get(
        'common/gacha_record/api/getGachaLog',
        queryParameters: params,
      );
      if (resp.data['retcode'] == 0) {
        return NapGachaModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get gacha logs ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get gacha logs ${e.toString()}',
      );
    }
  }
}
