// Package imports:
import 'package:json_annotation/json_annotation.dart';

/// 米社JSBridge相关的数据结构
part 'bbs_bridge_model.g.dart';

/// 米社JSBridge相关的数据结构
@JsonSerializable(genericArgumentFactories: true)
class BbsBridgeModel<T> {
  /// method
  @JsonKey(name: 'method')
  String method;

  /// callback
  @JsonKey(name: 'callback')
  String? callback;

  /// payload
  @JsonKey(name: 'payload')
  T? payload;

  /// constructor
  BbsBridgeModel({
    required this.method,
    required this.callback,
    required this.payload,
  });

  /// from json
  factory BbsBridgeModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BbsBridgeModelFromJson(json, fromJsonT);

  /// to json
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BbsBridgeModelToJson(this, toJsonT);
}

/// 数据-getActionTicket
@JsonSerializable()
class BbsBridgePayloadGetActionTicket {
  /// action_type
  @JsonKey(name: 'action_type')
  String actionType;

  /// constructor
  BbsBridgePayloadGetActionTicket({required this.actionType});

  /// from json
  factory BbsBridgePayloadGetActionTicket.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePayloadGetActionTicketFromJson(json);

  /// to json
  Map<String, dynamic> toJson() =>
      _$BbsBridgePayloadGetActionTicketToJson(this);
}

/// 事件-getActionTicket
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsBridgeGetActionTicket
    extends BbsBridgeModel<BbsBridgePayloadGetActionTicket> {
  /// constructor
  BbsBridgeGetActionTicket({
    required super.method,
    required super.callback,
    required super.payload,
  });

  /// from json
  factory BbsBridgeGetActionTicket.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgeGetActionTicketFromJson(json);
}

/// 数据-getDS2
@JsonSerializable()
class BbsBridgePayloadGetDS2 {
  /// query
  @JsonKey(name: 'query')
  dynamic query;

  /// body
  @JsonKey(name: 'body')
  dynamic body;

  /// constructor
  BbsBridgePayloadGetDS2({this.query, this.body});

  /// from json
  factory BbsBridgePayloadGetDS2.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePayloadGetDS2FromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsBridgePayloadGetDS2ToJson(this);
}

/// 事件-getDS2
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsBridgeGetDS2 extends BbsBridgeModel<BbsBridgePayloadGetDS2> {
  /// constructor
  BbsBridgeGetDS2({
    required super.method,
    required super.callback,
    required super.payload,
  });

  /// from json
  factory BbsBridgeGetDS2.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgeGetDS2FromJson(json);
}

/// 数据-pushPage
@JsonSerializable()
class BbsBridgePayloadPushPage {
  /// page
  @JsonKey(name: 'page')
  String page;

  /// constructor
  BbsBridgePayloadPushPage({required this.page});

  /// from json
  factory BbsBridgePayloadPushPage.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePayloadPushPageFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsBridgePayloadPushPageToJson(this);
}

/// 事件-pushPage
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsBridgePushPage extends BbsBridgeModel<BbsBridgePayloadPushPage> {
  /// constructor
  BbsBridgePushPage({
    required super.method,
    required super.callback,
    required super.payload,
  });

  /// from json
  factory BbsBridgePushPage.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePushPageFromJson(json);
}

/// 数据-setPresentationStyle
@JsonSerializable()
class BbsBridgePayloadSetPresentationStyle {
  /// style
  @JsonKey(name: 'style')
  String style;

  /// navigationBar
  @JsonKey(name: 'navigationBar')
  dynamic navigationBar;

  /// statusBar
  @JsonKey(name: 'statusBar')
  dynamic statusBar;

  /// constructor
  BbsBridgePayloadSetPresentationStyle({
    required this.style,
    this.navigationBar,
    this.statusBar,
  });

  /// from json
  factory BbsBridgePayloadSetPresentationStyle.fromJson(
          Map<String, dynamic> json) =>
      _$BbsBridgePayloadSetPresentationStyleFromJson(json);

  /// to json
  Map<String, dynamic> toJson() =>
      _$BbsBridgePayloadSetPresentationStyleToJson(this);
}

/// 事件-setPresentationStyle
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsBridgeSetPresentationStyle
    extends BbsBridgeModel<BbsBridgePayloadSetPresentationStyle> {
  /// constructor
  BbsBridgeSetPresentationStyle({
    required super.method,
    required super.callback,
    required super.payload,
  });

  /// from json
  factory BbsBridgeSetPresentationStyle.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgeSetPresentationStyleFromJson(json);
}

/// 数据-share-content
@JsonSerializable()
class BbsBridgePayloadShareContent {
  /// title
  @JsonKey(name: 'title')
  String? title;

  /// description
  @JsonKey(name: 'description')
  String? description;

  /// link
  @JsonKey(name: 'link')
  String? link;

  /// image_url
  @JsonKey(name: 'image_url')
  String? imageUrl;

  /// preview
  @JsonKey(name: 'preview')
  bool? preview;

  /// image_base64
  @JsonKey(name: 'image_base64')
  String? imageBase64;

  /// constructor
  BbsBridgePayloadShareContent({
    this.title,
    this.description,
    this.link,
    this.imageUrl,
    this.preview,
    this.imageBase64,
  });

  /// from json
  factory BbsBridgePayloadShareContent.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePayloadShareContentFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsBridgePayloadShareContentToJson(this);
}

/// 数据-share
@JsonSerializable(explicitToJson: true)
class BbsBridgePayloadShare {
  /// type
  @JsonKey(name: 'type')
  String type;

  /// content
  @JsonKey(name: 'content')
  BbsBridgePayloadShareContent content;

  /// constructor
  BbsBridgePayloadShare({required this.type, required this.content});

  /// from json
  factory BbsBridgePayloadShare.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgePayloadShareFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$BbsBridgePayloadShareToJson(this);
}

/// 事件-share
@JsonSerializable(explicitToJson: true, createToJson: false)
class BbsBridgeShare extends BbsBridgeModel<BbsBridgePayloadShare> {
  /// constructor
  BbsBridgeShare({
    required super.method,
    required super.callback,
    required super.payload,
  });

  /// from json
  factory BbsBridgeShare.fromJson(Map<String, dynamic> json) =>
      _$BbsBridgeShareFromJson(json);
}
