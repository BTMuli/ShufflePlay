// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/token/bbs_token_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../core/client.dart';
import '../core/gen_ds_header.dart';

class SprBbsApiToken {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://passport-api.mihoyo.com/account/auth/api/';

  /// 构造函数
  SprBbsApiToken() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 根据stoken获取ltoken
  Future<BBSResp> getLToken(UserBBSModelCookie ck) async {
    var device = await sqlite.readDevice();
    var cookie = {"mid": ck.mid, "stoken": ck.stoken};
    var params = {"stoken": ck.stoken};
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
    );
    try {
      var resp = await client.dio.get(
        'getLTokenBySToken',
        queryParameters: params,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return BbsTokenModelLbSResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get ltoken ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get ltoken ${e.toString()}',
      );
    }
  }

  /// 根据stoken获取cookieToken
  Future<BBSResp> getCookieToken(UserBBSModelCookie ck) async {
    var device = await sqlite.readDevice();
    var cookie = {"mid": ck.mid, "stoken": ck.stoken};
    var params = {"stoken": ck.stoken};
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
    );
    try {
      var resp = await client.dio.get(
        'getCookieAccountInfoBySToken',
        queryParameters: params,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return BbsTokenModelCbSResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get cookieToken ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get cookieToken ${e.toString()}',
      );
    }
  }
}
