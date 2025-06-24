// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/device/bbs_device_model.dart';
import '../../models/database/app/app_config_model.dart';
import '../../shared/database/app_config.dart';
import '../../shared/utils/gen_random_str.dart';
import '../core/client.dart';

class SprBbsApiDevice {
  /// 数据库
  final SpsAppConfig sqlite = SpsAppConfig();

  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://public-data-api.mihoyo.com';

  /// 构造函数
  SprBbsApiDevice() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取请求头
  Options getOptions() {
    return Options(
      headers: {
        "user-agent": bbsUaMobile,
        "x-rpc-app_version": bbsVersion,
        "x-rpc-client_type": "5",
        "x-requested-with": "com.mihoyo.hyperion",
        "referer": "https://webstatic.mihoyo.com/",
      },
      method: 'POST',
    );
  }

  /// 根据设备信息生成头部数据
  Map<String, dynamic> genDeviceFpExt(AppConfigModelDevice device) {
    return {
      'proxyStatus': 0,
      'isRoot': 0,
      'romCapacity': "512",
      'deviceName': device.deviceName,
      'productName': device.model,
      'romRemain': "512",
      'hostname': "dg02-pool03-kvm87",
      'screenSize': "1440x2905",
      'isTablet': 0,
      'aaid': "",
      'model': device.deviceName,
      'brand': "Xiaomi",
      'hardware': "qcom",
      'deviceType': "OP5913L1",
      'devId': "unknown",
      'serialNumber': "unknown",
      'sdCardCapacity': 512215,
      'buildTime': "1693626947000",
      'buildUser': "android-build",
      'simState': "5",
      'ramRemain': "239814",
      'appUpdateTimeDiff': 1702604034882,
      'deviceInfo': 'XiaoMi ${device.deviceName} '
          'OP5913L1:13 SKQ1.221119.001 '
          'T.118e6c7-5aa23-73911:user release-keys',
      'vaid': "",
      'buildType': "user",
      'sdkVersion': "34",
      'ui_mode': "UI_MODE_TYPE_NORMAL",
      'isMockLocation': 0,
      'cpuType': "arm64-v8a",
      'isAirMode': 0,
      'ringMode': 2,
      'chargeStatus': 1,
      'manufacturer': "XiaoMi",
      'emulatorStatus': 0,
      'appMemory': "512",
      'osVersion': "14",
      'vendor': "unknown",
      'accelerometer': "1.4883357x9.80665x-0.1963501",
      'sdRemain': 239600,
      'buildTags': "release-keys",
      'packageName': "com.mihoyo.hyperion",
      'networkType': "WiFi",
      'oaid': "",
      'debugStatus': 1,
      'ramCapacity': "469679",
      'magnetometer': "20.081251x-27.457501x2.1937501",
      'display': '${device.model}_13.1.0.181(CN01)',
      'appInstallTimeDiff': 1688455751496,
      'packageVersion': "2.20.1",
      'gyroscope': "0.030226856x-0.014647375x-0.0013732915",
      'batteryStatus': 100,
      'hasKeyboard': 0,
      'board': "taro",
    };
  }

  /// 获取设备指纹
  Future<BBSResp> getDeviceFp() async {
    var device = await sqlite.readDevice();
    if (device.deviceFp == "0" * 13) {
      device.deviceFp = genRandomStr(13, type: RandomStringType.hex);
    }
    Map<String, String> data = {
      'device_id': device.deviceId,
      'seed_id': device.seedId,
      'platform': '2',
      'seed_time': device.seedTime,
      'ext_fields': jsonEncode(genDeviceFpExt(device)),
      'app_name': 'bbs_cn',
      'bbs_device_id': device.deviceId,
      'device_fp': device.deviceFp,
    };
    try {
      var resp = await client.dio.request(
        '/device-fp/api/getFp',
        data: data,
        options: getOptions(),
      );
      if (resp.data['retcode'] == 0) {
        return BbsDeviceModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Failed to get device fp ${e.response?.data}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[UnknownException] Failed to get device fp $e',
      );
    }
  }
}
