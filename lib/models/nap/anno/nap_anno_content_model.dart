// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../../plugins/UIGF/models/uigf_enum.dart';
import '../../bbs/bbs_base_model.dart';

/// 游戏内公告内容返回数据
part 'nap_anno_content_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NapAnnoContentModelResp extends BBSResp<NapAnnoContentModelData> {
  NapAnnoContentModelResp({
    required super.retcode,
    required super.message,
    required NapAnnoContentModelData super.data,
  });

  factory NapAnnoContentModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoContentModelRespFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NapAnnoContentModelData {
  /// list
  @JsonKey(name: 'list')
  final List<NapAnnoContentModel> list;

  /// pic_list
  @JsonKey(name: 'pic_list')
  final List<dynamic> picList;

  /// pic_total
  @JsonKey(name: 'pic_total')
  final int picTotal;

  /// total
  @JsonKey(name: 'total')
  final int total;

  /// constructor
  NapAnnoContentModelData({
    required this.list,
    required this.picList,
    required this.picTotal,
    required this.total,
  });

  /// from json
  factory NapAnnoContentModelData.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoContentModelDataFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAnnoContentModelDataToJson(this);
}

@JsonSerializable()
class NapAnnoContentModel {
  /// ann_id
  @JsonKey(name: 'ann_id')
  final int annId;

  /// banner
  @JsonKey(name: 'banner')
  final String banner;

  /// content
  @JsonKey(name: 'content')
  final String content;

  /// lang
  @JsonKey(name: 'lang')
  final UigfLanguage lang;

  /// subtitle
  @JsonKey(name: 'subtitle')
  final String subtitle;

  /// title
  @JsonKey(name: 'title')
  final String title;

  /// constructor
  NapAnnoContentModel({
    required this.annId,
    required this.banner,
    required this.content,
    required this.lang,
    required this.subtitle,
    required this.title,
  });

  /// from json
  factory NapAnnoContentModel.fromJson(Map<String, dynamic> json) =>
      _$NapAnnoContentModelFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapAnnoContentModelToJson(this);
}
