// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/token/nap_auth_ticket_model.dart';
import '../core/client.dart';

class SprNapApiPassport {
  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://passport-api.mihoyo.com/';

  /// 构造函数
  SprNapApiPassport() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取登录所需 authTicket
  Future<BBSResp> getLoginAuthTicket(
    UserNapModel account,
    UserBBSModelCookie ck,
  ) async {
    var params = {
      "game_biz": account.gameBiz,
      "stoken": ck.stoken,
      "uid": account.uid,
      "mid": ck.mid,
    };
    var headers = {
      "x-rpc-client_type": "3",
      "x-rpc-game_biz": account.gameBiz,
      "x-rpc-hyp_web_source": "nap",
      "x-rpc-app_id": "ddxf5dufpuyo",
    };
    try {
      var resp = await client.dio.post(
        'account/ma-cn-verifier/app/createAuthTicketByGameBiz',
        queryParameters: params,
        options: Options(headers: headers),
      );
      if (resp.data['retcode'] == 0) {
        return NapAuthTicketModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get login authTicket ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get login authTicket ${e.toString()}',
      );
    }
  }
}
