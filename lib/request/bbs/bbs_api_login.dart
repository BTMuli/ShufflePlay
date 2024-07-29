// Package imports:
import 'package:encrypt/encrypt.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/database/app/app_config_model.dart';
import '../core/client.dart';

const bbsRsaPubKey = '''
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDvekdPMHN3AYhm/vktJT+YJr7cI5DcsNKqdsx5DZX0gDuWFuIjzdwButrIYPNmRJ1G8ybDIF7oDW2eEpm5sMbL9zs
9ExXCdvqrn51qELbqj0XxtMTIpaCHFSI50PfPpTFV9Xt/hmyVwokoOXFlAEgCn+Q
CgGs52bFoYMtyi+xEQIDAQAB
-----END PUBLIC KEY-----
''';

/// 获取短信验证码
Future<BBSResp> getPhoneCaptcha(
  String phone,
  String aigis,
  AppConfigModelDevice device,
) async {
  const url =
      "https://passport-api.mihoyo.com/account/ma-cn-verifier/verifier/createLoginCaptcha";
  var header = {
    "x-rpc-aigis": aigis,
    "x-rpc-app_version": bbsVersion,
    "x-rpc-client_type": "2",
    "x-rpc-app_id": bbsAppId,
    "x-rpc-device_fp": device.deviceFp,
    "x-rpc-device_id": device.deviceId,
    "x-rpc-device_name": device.deviceName,
    "x-rpc-device_model": device.model,
    "user-agent": bbsUaMobile,
    "content-type": "application/json",
    "referer": "https://user.miyoushe.com/",
  };
  var client = SprClient.withHeader(header);
  dynamic publicKey = RSAKeyParser().parse(bbsRsaPubKey);
  var encrypter = Encrypter(RSA(publicKey: publicKey));
  var resp = await client.dio.post(
    url,
    data: {
      "area_code": encrypter.encrypt("+86").base64.toUpperCase(),
      "mobile": encrypter.encrypt(phone).base64.toUpperCase(),
    },
  );
  if (resp.data['retcode'] != 0) {
    var aigis = resp.headers.value('x-rpc-aigis');
    return BBSResp.error(
      retcode: resp.data['retcode'],
      message: resp.data['message'],
      data: aigis,
    );
  }
  return BBSResp(
    retcode: resp.data['retcode'],
    message: resp.data['message'],
    data: resp.data['data'],
  );
}
