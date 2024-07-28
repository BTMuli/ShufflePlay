// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// UIGF 数据结构中的枚举类

/// 数据对应的语言
@JsonEnum(valueField: 'value')
enum UigfLanguage {
  /// 德语
  de('de-de'),

  /// 英语
  en('en-us'),

  /// 西班牙语
  es('es-es'),

  /// 法语
  fr('fr-fr'),

  /// 印尼语
  id('id-id'),

  /// 意大利语
  it('it-it'),

  /// 日语
  ja('ja-jp'),

  /// 韩语
  ko('ko-kr'),

  /// 葡萄牙语
  pt('pt-pt'),

  /// 俄语
  ru('ru-ru'),

  /// 泰语
  th('th-th'),

  /// 土耳其语
  tr('tr-tr'),

  /// 越南语
  vi('vi-vn'),

  /// 简体中文
  zhHans('zh-cn'),

  /// 繁体中文
  zhHant('zh-tw');

  /// value
  final String value;

  const UigfLanguage(this.value);
}

/// zzz卡池类型枚举
@JsonEnum(valueField: 'value')
enum UigfNapPoolType {
  /// 常驻
  normal('1'),

  /// 角色UP
  upC('2'),

  /// 武器UP
  upW('3'),

  /// 邦布
  bond('5');

  final String value;

  const UigfNapPoolType(this.value);
}
