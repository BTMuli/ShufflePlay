// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/nap/account/nap_account_model.dart';
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
}
