// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/account/nap_account_model.dart';
import '../../models/nap/token/nap_authkey_model.dart';
import '../../shared/database/app_config.dart';
import '../core/client.dart';
import '../core/gen_ds_header.dart';

class SprNapApiAccount {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://api-takumi.mihoyo.com/';

  /// 构造函数
  SprNapApiAccount() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取用户角色
  Future<BBSResp> getGameAccounts(UserBBSModelCookie ck) async {
    var device = await sqlite.readDevice();
    var cookie = {"account_id": ck.accountId!, "cookie_token": ck.cookieToken!};
    var params = {"game_biz": "nap_cn"};
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
    );
    try {
      var resp = await client.dio.get(
        'binding/api/getUserGameRolesByCookie',
        queryParameters: params,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return NapAccountModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get game accounts ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get game accounts ${e.toString()}',
      );
    }
  }

  /// 生成authKey
  Future<BBSResp> genAuthKey(
    UserBBSModelCookie ck,
    UserNapModel account,
  ) async {
    var device = await sqlite.readDevice();
    var cookie = {"stoken": ck.stoken, "mid": ck.mid};
    var data = {
      "auth_appid": "webview_gacha",
      "game_biz": account.gameBiz,
      "game_uid": account.gameUid,
      "region": account.region,
    };
    var header = getDsReqHeader(
      cookie,
      "POST",
      data,
      BbsConstantSalt.lk2,
      device,
      isSign: true,
    );
    try {
      var resp = await client.dio.post(
        'binding/api/genAuthKey',
        data: data,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return NapAuthkeyModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to gen authKey ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to gen authKey ${e.toString()}',
      );
    }
  }
}
