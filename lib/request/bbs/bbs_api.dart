// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_base_model.dart';
import '../core/client.dart';
import 'bbs_api_login.dart';

class SprBBSApi {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// 获取短信验证码
  Future<BBSResp> getPhoneCaptchaResp(
    String phone, {
    String aigis = '',
  }) async {
    try {
      var device = await sqlite.readDevice();
      if (device.deviceFp == "0" * 13) {
        return BBSResp.error(retcode: -1033, message: 'Device is unregistered');
      }
      return await getPhoneCaptcha(client, phone, aigis, device);
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: 'Failed to get phone captcha ${e.response?.data}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: 'Failed to get phone captcha $e',
      );
    }
  }
}
