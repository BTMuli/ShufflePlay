// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:crypto/crypto.dart';

// Project imports:
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/database/app/app_config_model.dart';
import '../../utils/gen_random_str.dart';

/// 获取带有ds的请求头
Map<String, String> getDsReqHeader(
  Map<String, String> cookie,
  String method,
  dynamic data,
  BbsConstantSalt salt,
  AppConfigModelDevice device, {
  bool isSign = false,
}) {
  String ds;
  if (data is String) {
    ds = getDs(method, data, salt, isSign);
  } else {
    ds = getDs(method, transData(data), salt, isSign);
  }
  return {
    "user-agent": bbsUaPC,
    "x-rpc-app_version": bbsVersion,
    "x-rpc-client_type": "5",
    "x-requested-with": "com.mihoyo.hyperion",
    "referer": "https://webstatic.mihoyo.com/",
    "x-rpc-device_fp": device.deviceFp,
    "x-rpc-device_id": device.deviceId,
    "ds": ds,
    "cookie": transCookie(cookie),
  };
}

/// 获取ds
String getDs(String method, String data, BbsConstantSalt salt, bool isSign) {
  var saltValue = salt.salt;
  var time = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  var randomStr = genRandomStr(6);
  if (!isSign) {
    randomStr = genRandomStr(
      6,
      type: RandomStringType.number,
      min: 100000,
      max: 200000,
    );
  }
  var body = method == "GET" ? "" : data;
  var query = method == "GET" ? data : "";
  var hashStr = 'salt=$saltValue&t=$time&r=$randomStr&b=$body&q=$query';
  if (isSign) hashStr = 'salt=$saltValue&t=$time&r=$randomStr';
  var md5Str = md5.convert(utf8.encode(hashStr)).toString();
  return '$time,$randomStr,$md5Str';
}

/// 转换数据，按照字典序排序
String transData(Map<String, dynamic> data) {
  var keys = data.keys.toList();
  keys.sort();
  var result = '';
  for (var key in keys) {
    result += '$key=${data[key]}&';
  }
  return result.substring(0, result.length - 1);
}

/// 转换cookie
String transCookie(Map<String, String> cookie) {
  var result = '';
  for (var key in cookie.keys) {
    result += '$key=${cookie[key]};';
  }
  return result.substring(0, result.length - 1);
}
