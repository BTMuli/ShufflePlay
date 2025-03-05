// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/nap/account/nap_account_model.dart';
import '../../models/nap/avatar/nap_avatar_detail_model.dart';
import '../../models/nap/avatar/nap_avatar_list_model.dart';
import '../../shared/database/app_config.dart';
import '../core/client.dart';
import '../core/gen_ds_header.dart';

class SprNapApiRecord {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl =
      'https://api-takumi-record.mihoyo.com/event/game_record_zzz/api/zzz/';

  /// 构造函数
  SprNapApiRecord() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取角色列表
  Future<BBSResp> getAvatarList(
    NapAccountModel account,
    UserBBSModelCookie ck,
  ) async {
    var device = await sqlite.readDevice();
    var cookie = {"cookie_token": ck.cookieToken!, "account_id": ck.accountId!};
    var params = {'role_id': account.gameUid, 'server': account.region};
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
    );
    try {
      var resp = await client.dio.get(
        'avatar/basic',
        queryParameters: params,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return NapAvatarListModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get avatar list ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get avatar list ${e.toString()}',
      );
    }
  }

  /// 获取角色信息
  Future<BBSResp> getAvatarDetail(
    int avatarId,
    NapAccountModel account,
    UserBBSModelCookie ck,
  ) async {
    var device = await sqlite.readDevice();
    var cookie = {"cookie_token": ck.cookieToken!, "account_id": ck.accountId!};
    var params = {
      'id_list[]': avatarId,
      'need_wiki': false,
      'server': account.region,
      'role_id': account.gameUid
    };
    var header = getDsReqHeader(
      cookie,
      "GET",
      params,
      BbsConstantSalt.x4,
      device,
    );
    try {
      var resp = await client.dio.get(
        'avatar/info',
        queryParameters: params,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return NapAvatarDetailModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get avatar detail ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get avatar detail ${e.toString()}',
      );
    }
  }
}
