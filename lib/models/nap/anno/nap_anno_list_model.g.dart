// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_anno_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAnnoListModelResp _$NapAnnoListModelRespFromJson(
        Map<String, dynamic> json) =>
    NapAnnoListModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data: NapAnnoListModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NapAnnoListModelRespToJson(
        NapAnnoListModelResp instance) =>
    <String, dynamic>{
      'retcode': instance.retcode,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

NapAnnoListModelData _$NapAnnoListModelDataFromJson(
        Map<String, dynamic> json) =>
    NapAnnoListModelData(
      alert: json['alert'] as bool,
      alertId: (json['alert_id'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => NapAnnoListModelList.fromJson(e as Map<String, dynamic>))
          .toList(),
      picAlert: json['pic_alert'] as bool,
      picAlertId: (json['pic_alert_id'] as num).toInt(),
      picList: json['pic_list'] as List<dynamic>,
      picTotal: (json['pic_total'] as num).toInt(),
      picTypeList: json['pic_type_list'] as List<dynamic>,
      staticSign: json['static_sign'] as String,
      t: json['t'] as String,
      timezone: (json['timezone'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      typeList: (json['type_list'] as List<dynamic>)
          .map((e) =>
              NapAnnoListModelTypeList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAnnoListModelDataToJson(
        NapAnnoListModelData instance) =>
    <String, dynamic>{
      'alert': instance.alert,
      'alert_id': instance.alertId,
      'list': instance.list.map((e) => e.toJson()).toList(),
      'pic_alert': instance.picAlert,
      'pic_alert_id': instance.picAlertId,
      'pic_list': instance.picList,
      'pic_total': instance.picTotal,
      'pic_type_list': instance.picTypeList,
      'static_sign': instance.staticSign,
      't': instance.t,
      'timezone': instance.timezone,
      'total': instance.total,
      'type_list': instance.typeList.map((e) => e.toJson()).toList(),
    };

NapAnnoListModelTypeList _$NapAnnoListModelTypeListFromJson(
        Map<String, dynamic> json) =>
    NapAnnoListModelTypeList(
      id: (json['id'] as num).toInt(),
      mi18nName: json['mi18n_name'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$NapAnnoListModelTypeListToJson(
        NapAnnoListModelTypeList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mi18n_name': instance.mi18nName,
      'name': instance.name,
    };

NapAnnoListModelList _$NapAnnoListModelListFromJson(
        Map<String, dynamic> json) =>
    NapAnnoListModelList(
      typeId: (json['type_id'] as num).toInt(),
      typeLabel: json['type_label'] as String,
      list: (json['list'] as List<dynamic>)
          .map((e) => NapAnnoListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NapAnnoListModelListToJson(
        NapAnnoListModelList instance) =>
    <String, dynamic>{
      'type_id': instance.typeId,
      'type_label': instance.typeLabel,
      'list': instance.list.map((e) => e.toJson()).toList(),
    };

NapAnnoListModel _$NapAnnoListModelFromJson(Map<String, dynamic> json) =>
    NapAnnoListModel(
      alert: (json['alert'] as num).toInt(),
      annId: (json['ann_id'] as num).toInt(),
      banner: json['banner'] as String,
      content: json['content'] as String,
      endTime: json['end_time'] as String,
      extraRemind: (json['extra_remind'] as num).toInt(),
      hasContent: json['has_content'] as bool,
      lang: $enumDecode(_$UigfLanguageEnumMap, json['lang']),
      loginAlert: (json['login_alert'] as num).toInt(),
      remind: (json['remind'] as num).toInt(),
      remindVer: (json['remind_ver'] as num).toInt(),
      startTime: json['start_time'] as String,
      subtitle: json['subtitle'] as String,
      tagEndTime: json['tag_end_time'] as String,
      tagIcon: json['tag_icon'] as String,
      tagIconHover: json['tag_icon_hover'] as String,
      tagLabel: json['tag_label'] as String,
      tagStartTime: json['tag_start_time'] as String,
      title: json['title'] as String,
      type: (json['type'] as num).toInt(),
      typeLabel: json['type_label'] as String,
    );

Map<String, dynamic> _$NapAnnoListModelToJson(NapAnnoListModel instance) =>
    <String, dynamic>{
      'alert': instance.alert,
      'ann_id': instance.annId,
      'banner': instance.banner,
      'content': instance.content,
      'end_time': instance.endTime,
      'extra_remind': instance.extraRemind,
      'has_content': instance.hasContent,
      'lang': _$UigfLanguageEnumMap[instance.lang]!,
      'login_alert': instance.loginAlert,
      'remind': instance.remind,
      'remind_ver': instance.remindVer,
      'start_time': instance.startTime,
      'subtitle': instance.subtitle,
      'tag_end_time': instance.tagEndTime,
      'tag_icon': instance.tagIcon,
      'tag_icon_hover': instance.tagIconHover,
      'tag_label': instance.tagLabel,
      'tag_start_time': instance.tagStartTime,
      'title': instance.title,
      'type': instance.type,
      'type_label': instance.typeLabel,
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
