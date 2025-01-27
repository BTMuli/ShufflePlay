import 'package:dio/dio.dart';

import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/login/bbs_login_qr_model.dart';
import '../../shared/database/app_config.dart';
import '../core/client.dart';

class SprBbsApiLoginQr {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl =
      'https://passport-api.mihoyo.com/account/ma-cn-passport/app/';

  /// HYContainerVersion
  final String hlv = "1.3.3.182";

  /// 构造函数
  SprBbsApiLoginQr() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取二维码
  Future<BBSResp> getLoginQr() async {
    var device = await sqlite.readDevice();
    var header = {
      "x-rpc-device_id": device.deviceId,
      "user-agent": "HYPContainer/$hlv",
      "x-rpc-app_id": "ddxf5dufpuyo",
      "x-rpc-client_type": "3",
    };
    try {
      var resp = await client.dio.post(
        'createQRLogin',
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return BbsLoginQrGetQrResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get login qr ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get login qr ${e.toString()}',
      );
    }
  }

  /// 获取登录状态
  Future<BBSResp> getQRStatus(String ticket) async {
    var device = await sqlite.readDevice();
    var header = {
      "x-rpc-device_id": device.deviceId,
      "user-agent": "HYPContainer/$hlv",
      "x-rpc-app_id": "ddxf5dufpuyo",
      "x-rpc-client_type": "3",
    };
    var data = {"ticket": ticket};
    try {
      var resp = await client.dio.post(
        'queryQRLoginStatus',
        data: data,
        options: Options(headers: header),
      );
      if (resp.data['retcode'] == 0) {
        return BbsLoginQrStatResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get login qr status ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get login qr status ${e.toString()}',
      );
    }
  }
}
