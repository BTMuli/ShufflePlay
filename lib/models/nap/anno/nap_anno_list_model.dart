// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../../plugins/UIGF/models/uigf_enum.dart';
import '../../bbs/bbs_base_model.dart';

/// 游戏内公告列表返回数据
part 'nap_anno_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NapAnnoListModelResp extends BBSResp<NapAnnoListModelData> {
  NapAnnoListModelResp({
    required super.retcode,
    required super.message,
    required NapAnnoListModelData super.data,
  });

  factory NapAnnoListModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoListModelRespFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NapAnnoListModelData {
  /// alert
  @JsonKey(name: 'alert')
  final bool alert;

  /// alert_id
  @JsonKey(name: 'alert_id')
  final int alertId;

  /// list
  @JsonKey(name: 'list')
  final List<NapAnnoListModelList> list;

  /// pic_alert
  @JsonKey(name: 'pic_alert')
  final bool picAlert;

  /// pic_alert_id
  @JsonKey(name: 'pic_alert_id')
  final int picAlertId;

  /// pic_list
  @JsonKey(name: 'pic_list')
  final List<dynamic> picList;

  /// pic_total
  @JsonKey(name: 'pic_total')
  final int picTotal;

  /// pic_type_list
  @JsonKey(name: 'pic_type_list')
  final List<dynamic> picTypeList;

  /// static_sign
  @JsonKey(name: 'static_sign')
  final String staticSign;

  /// t
  @JsonKey(name: 't')
  final String t;

  /// timezone
  @JsonKey(name: 'timezone')
  final int timezone;

  /// total
  @JsonKey(name: 'total')
  final int total;

  /// type_list
  @JsonKey(name: 'type_list')
  final List<NapAnnoListModelTypeList> typeList;

  /// constructor
  NapAnnoListModelData({
    required this.alert,
    required this.alertId,
    required this.list,
    required this.picAlert,
    required this.picAlertId,
    required this.picList,
    required this.picTotal,
    required this.picTypeList,
    required this.staticSign,
    required this.t,
    required this.timezone,
    required this.total,
    required this.typeList,
  });

  factory NapAnnoListModelData.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoListModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$NapAnnoListModelDataToJson(this);
}

@JsonSerializable()
class NapAnnoListModelTypeList {
  /// id
  @JsonKey(name: 'id')
  final int id;

  /// mi18n_name
  @JsonKey(name: 'mi18n_name')
  final String mi18nName;

  /// name
  @JsonKey(name: 'name')
  final String name;

  /// constructor
  NapAnnoListModelTypeList({
    required this.id,
    required this.mi18nName,
    required this.name,
  });

  factory NapAnnoListModelTypeList.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoListModelTypeListFromJson(json);

  Map<String, dynamic> toJson() => _$NapAnnoListModelTypeListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NapAnnoListModelList {
  /// type_id
  @JsonKey(name: 'type_id')
  final int typeId;

  /// type_label
  @JsonKey(name: 'type_label')
  final String typeLabel;

  /// list
  @JsonKey(name: 'list')
  final List<NapAnnoListModel> list;

  /// constructor
  NapAnnoListModelList({
    required this.typeId,
    required this.typeLabel,
    required this.list,
  });

  factory NapAnnoListModelList.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoListModelListFromJson(json);

  Map<String, dynamic> toJson() => _$NapAnnoListModelListToJson(this);
}

@JsonSerializable()
class NapAnnoListModel {
  /// alert
  @JsonKey(name: 'alert')
  final int alert;

  /// anno_id
  @JsonKey(name: 'ann_id')
  final int annId;

  /// banner
  @JsonKey(name: 'banner')
  final String banner;

  /// content
  @JsonKey(name: 'content')
  final String content;

  /// end_time format: yyyy-MM-dd HH:mm:ss
  @JsonKey(name: 'end_time')
  final String endTime;

  /// extra_remind
  @JsonKey(name: 'extra_remind')
  final int extraRemind;

  /// has_content
  @JsonKey(name: 'has_content')
  final bool hasContent;

  /// lang
  @JsonKey(name: 'lang')
  final UigfLanguage lang;

  /// login_alert
  @JsonKey(name: 'login_alert')
  final int loginAlert;

  /// remind
  @JsonKey(name: 'remind')
  final int remind;

  /// remind_ver
  @JsonKey(name: 'remind_ver')
  final int remindVer;

  /// start_time format: yyyy-MM-dd HH:mm:ss
  @JsonKey(name: 'start_time')
  final String startTime;

  /// subtitle
  @JsonKey(name: 'subtitle')
  final String subtitle;

  /// tag_end_time format: yyyy-MM-dd HH:mm:ss
  @JsonKey(name: 'tag_end_time')
  final String tagEndTime;

  /// tag_icon
  @JsonKey(name: 'tag_icon')
  final String tagIcon;

  /// tag_icon_hover
  @JsonKey(name: 'tag_icon_hover')
  final String tagIconHover;

  /// tag_label
  @JsonKey(name: 'tag_label')
  final String tagLabel;

  /// tag_start_time format: yyyy-MM-dd HH:mm:ss
  @JsonKey(name: 'tag_start_time')
  final String tagStartTime;

  /// title
  @JsonKey(name: 'title')
  final String title;

  /// type
  @JsonKey(name: 'type')
  final int type;

  /// type_label
  @JsonKey(name: 'type_label')
  final String typeLabel;

  /// constructor
  NapAnnoListModel({
    required this.alert,
    required this.annId,
    required this.banner,
    required this.content,
    required this.endTime,
    required this.extraRemind,
    required this.hasContent,
    required this.lang,
    required this.loginAlert,
    required this.remind,
    required this.remindVer,
    required this.startTime,
    required this.subtitle,
    required this.tagEndTime,
    required this.tagIcon,
    required this.tagIconHover,
    required this.tagLabel,
    required this.tagStartTime,
    required this.title,
    required this.type,
    required this.typeLabel,
  });

  factory NapAnnoListModel.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoListModelFromJson(json);

  Map<String, dynamic> toJson() => _$NapAnnoListModelToJson(this);
}
