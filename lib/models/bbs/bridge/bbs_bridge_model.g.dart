// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bbs_bridge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BbsBridgeModel<T> _$BbsBridgeModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BbsBridgeModel<T>(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: _$nullableGenericFromJson(json['payload'], fromJsonT),
    );

Map<String, dynamic> _$BbsBridgeModelToJson<T>(
  BbsBridgeModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'method': instance.method,
      'callback': instance.callback,
      'payload': _$nullableGenericToJson(instance.payload, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

BbsBridgePayloadGetActionTicket _$BbsBridgePayloadGetActionTicketFromJson(
        Map<String, dynamic> json) =>
    BbsBridgePayloadGetActionTicket(
      actionType: json['action_type'] as String,
    );

Map<String, dynamic> _$BbsBridgePayloadGetActionTicketToJson(
        BbsBridgePayloadGetActionTicket instance) =>
    <String, dynamic>{
      'action_type': instance.actionType,
    };

BbsBridgeGetActionTicket _$BbsBridgeGetActionTicketFromJson(
        Map<String, dynamic> json) =>
    BbsBridgeGetActionTicket(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: json['payload'] == null
          ? null
          : BbsBridgePayloadGetActionTicket.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

BbsBridgePayloadGetDS2 _$BbsBridgePayloadGetDS2FromJson(
        Map<String, dynamic> json) =>
    BbsBridgePayloadGetDS2(
      query: json['query'],
      body: json['body'],
    );

Map<String, dynamic> _$BbsBridgePayloadGetDS2ToJson(
        BbsBridgePayloadGetDS2 instance) =>
    <String, dynamic>{
      'query': instance.query,
      'body': instance.body,
    };

BbsBridgeGetDS2 _$BbsBridgeGetDS2FromJson(Map<String, dynamic> json) =>
    BbsBridgeGetDS2(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: json['payload'] == null
          ? null
          : BbsBridgePayloadGetDS2.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

BbsBridgePayloadPushPage _$BbsBridgePayloadPushPageFromJson(
        Map<String, dynamic> json) =>
    BbsBridgePayloadPushPage(
      page: json['page'] as String,
    );

Map<String, dynamic> _$BbsBridgePayloadPushPageToJson(
        BbsBridgePayloadPushPage instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

BbsBridgePushPage _$BbsBridgePushPageFromJson(Map<String, dynamic> json) =>
    BbsBridgePushPage(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: json['payload'] == null
          ? null
          : BbsBridgePayloadPushPage.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

BbsBridgePayloadSetPresentationStyle
    _$BbsBridgePayloadSetPresentationStyleFromJson(Map<String, dynamic> json) =>
        BbsBridgePayloadSetPresentationStyle(
          style: json['style'] as String,
          navigationBar: json['navigationBar'],
          statusBar: json['statusBar'],
        );

Map<String, dynamic> _$BbsBridgePayloadSetPresentationStyleToJson(
        BbsBridgePayloadSetPresentationStyle instance) =>
    <String, dynamic>{
      'style': instance.style,
      'navigationBar': instance.navigationBar,
      'statusBar': instance.statusBar,
    };

BbsBridgeSetPresentationStyle _$BbsBridgeSetPresentationStyleFromJson(
        Map<String, dynamic> json) =>
    BbsBridgeSetPresentationStyle(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: json['payload'] == null
          ? null
          : BbsBridgePayloadSetPresentationStyle.fromJson(
              json['payload'] as Map<String, dynamic>),
    );

BbsBridgePayloadShareContent _$BbsBridgePayloadShareContentFromJson(
        Map<String, dynamic> json) =>
    BbsBridgePayloadShareContent(
      title: json['title'] as String?,
      description: json['description'] as String?,
      link: json['link'] as String?,
      imageUrl: json['image_url'] as String?,
      preview: json['preview'] as bool?,
      imageBase64: json['image_base64'] as String?,
    );

Map<String, dynamic> _$BbsBridgePayloadShareContentToJson(
        BbsBridgePayloadShareContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'image_url': instance.imageUrl,
      'preview': instance.preview,
      'image_base64': instance.imageBase64,
    };

BbsBridgePayloadShare _$BbsBridgePayloadShareFromJson(
        Map<String, dynamic> json) =>
    BbsBridgePayloadShare(
      type: json['type'] as String,
      content: BbsBridgePayloadShareContent.fromJson(
          json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BbsBridgePayloadShareToJson(
        BbsBridgePayloadShare instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content.toJson(),
    };

BbsBridgeShare _$BbsBridgeShareFromJson(Map<String, dynamic> json) =>
    BbsBridgeShare(
      method: json['method'] as String,
      callback: json['callback'] as String?,
      payload: json['payload'] == null
          ? null
          : BbsBridgePayloadShare.fromJson(
              json['payload'] as Map<String, dynamic>),
    );
