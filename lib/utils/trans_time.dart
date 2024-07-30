// Package imports:
import 'package:jiffy/jiffy.dart';

/// 将指定时区[timezone]跟正则[pattern]匹配的时间字符串[time]转换成UTC时间
/// 目标格式默认为`YYYY-MM-DD HH:mm:ss`，如果指定了[pattern]则使用指定的格式
String toUtcTime(
  int timezone,
  String time, {
  String pattern = 'yyyy-MM-dd HH:mm:ss',
  String? format,
}) {
  var parseTimeStamp = Jiffy.parse(
    time,
    pattern: pattern,
    isUtc: true,
  ).add(hours: -timezone);
  if (format != null) {
    return parseTimeStamp.format(pattern: format);
  }
  return parseTimeStamp.format(pattern: pattern);
}

/// 将UTC时间字符串[time]转换成指定时区[timezone]的时间
/// 目标格式默认为`YYYY-MM-DD HH:mm:ss`，如果指定了[pattern]则使用指定的格式
String fromUtcTime(
  int timezone,
  String time, {
  String pattern = 'YYYY-MM-DD HH:mm:ss',
  String? format,
}) {
  var parseTimeStamp = Jiffy.parse(
    time,
    pattern: pattern,
    isUtc: true,
  ).add(hours: timezone);
  if (format != null) {
    return parseTimeStamp.format(pattern: format);
  }
  return parseTimeStamp.format(pattern: pattern);
}
