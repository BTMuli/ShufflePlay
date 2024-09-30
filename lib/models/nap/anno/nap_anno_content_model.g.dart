// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_anno_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAnnoContentModelResp _$NapAnnoContentModelRespFromJson(
        Map<String, dynamic> json) =>
    NapAnnoContentModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapAnnoContentModelData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

NapAnnoContentModelData _$NapAnnoContentModelDataFromJson(
        Map<String, dynamic> json) =>
    NapAnnoContentModelData(
      list: (json['list'] as List<dynamic>)
          .map((e) => NapAnnoContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      picList: json['pic_list'] as List<dynamic>,
      picTotal: (json['pic_total'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$NapAnnoContentModelDataToJson(
        NapAnnoContentModelData instance) =>
    <String, dynamic>{
      'list': instance.list.map((e) => e.toJson()).toList(),
      'pic_list': instance.picList,
      'pic_total': instance.picTotal,
      'total': instance.total,
    };

NapAnnoContentModel _$NapAnnoContentModelFromJson(Map<String, dynamic> json) =>
    NapAnnoContentModel(
      annId: (json['ann_id'] as num).toInt(),
      banner: json['banner'] as String,
      content: json['content'] as String,
      lang: $enumDecode(_$UigfLanguageEnumMap, json['lang']),
      subtitle: json['subtitle'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$NapAnnoContentModelToJson(
        NapAnnoContentModel instance) =>
    <String, dynamic>{
      'ann_id': instance.annId,
      'banner': instance.banner,
      'content': instance.content,
      'lang': _$UigfLanguageEnumMap[instance.lang]!,
      'subtitle': instance.subtitle,
      'title': instance.title,
    };

const _$UigfLanguageEnumMap = {
  UigfLanguage.de: 'de-de',
  UigfLanguage.en: 'en-us',
  UigfLanguage.es: 'es-es',
  UigfLanguage.fr: 'fr-fr',
  UigfLanguage.id: 'id-id',
  UigfLanguage.it: 'it-it',
  UigfLanguage.ja: 'ja-jp',
  UigfLanguage.ko: 'ko-kr',
  UigfLanguage.pt: 'pt-pt',
  UigfLanguage.ru: 'ru-ru',
  UigfLanguage.th: 'th-th',
  UigfLanguage.tr: 'tr-tr',
  UigfLanguage.vi: 'vi-vn',
  UigfLanguage.zhHans: 'zh-cn',
  UigfLanguage.zhHant: 'zh-tw',
};
