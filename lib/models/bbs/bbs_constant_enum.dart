// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// 米游社相关的一些常量
const bbsVersion = '2.76.1';
const bbsUaPC =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) miHoYoBBS/$bbsVersion';
const bbsUaMobile =
    'Mozilla/5.0 (Linux; Android 12) Mobile miHoYoBBS/$bbsVersion';
const bbsAppId = 'bll8iq97cem8';

@JsonEnum(valueField: 'value')
enum BbsConstantSalt {
  /// x2 salt
  k2('k2'),

  /// lk2 salt
  lk2('lk2'),

  /// x4 salt
  x4('x4'),

  /// x6 salt
  x6('x6'),

  /// prod salt
  prod('prod');

  /// value
  final String value;

  const BbsConstantSalt(this.value);
}

extension BbsConstantSaltExtension on BbsConstantSalt {
  String get salt {
    switch (this) {
      case BbsConstantSalt.k2:
        return 'OZatXfBgOYfCeDxVQwkEnFHFxJNtCrzB';
      case BbsConstantSalt.lk2:
        return 'FyZqfQfTDamvpNGuTMPkgyNOEpYQlBQf';
      case BbsConstantSalt.x4:
        return 'xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs';
      case BbsConstantSalt.x6:
        return 't0qEgfub6cvueAPgR5m9aQWWVciEer7v';
      case BbsConstantSalt.prod:
        return 't0qEgfub6cvueAPgR5m9aQWWVciEer7v';
      default:
        return value;
    }
  }
}
