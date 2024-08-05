// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/info/bbs_info_user_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../core/client.dart';
import '../core/gen_ds_header.dart';

class SprBbsApiInfo {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://bbs-api.miyoushe.com/';

  /// 构造函数
  SprBbsApiInfo() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取用户信息
  Future<BBSResp> getUserInfo(UserBBSModelCookie ck) async {
    var device = await sqlite.readDevice();
    var cookie = {"cookie_token": ck.cookieToken!, "account_id": ck.accountId!};
    var params = {"gids": "8"}; // 这边的 8 是绝区零对应的 gid
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
      isSign: true,
    );
    try {
      var resp = await client.dio.get(
        'user/wapi/getUserFullInfo',
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return BbsInfoUserModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get user info ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get user info ${e.toString()}',
      );
    }
  }
}
