// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_gacha_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGachaModel _$UserGachaModelFromJson(Map<String, dynamic> json) =>
    UserGachaModel(
      uid: json['uid'] as String,
      gachaType: $enumDecode(_$UigfNapPoolTypeEnumMap, json['gacha_type']),
      itemId: json['item_id'] as String,
      time: json['time'] as String,
      id: json['id'] as String,
      gachaId: json['gacha_id'] as String?,
      count: json['count'] as String?,
      itemType: json['item_type'] as String?,
      name: json['name'] as String?,
      rankType: json['rank_type'] as String?,
    );

Map<String, dynamic> _$UserGachaModelToJson(UserGachaModel instance) =>
    <String, dynamic>{
      'gacha_id': instance.gachaId,
      'gacha_type': _$UigfNapPoolTypeEnumMap[instance.gachaType]!,
      'item_id': instance.itemId,
      'count': instance.count,
      'time': instance.time,
      'name': instance.name,
      'item_type': instance.itemType,
      'rank_type': instance.rankType,
      'id': instance.id,
      'uid': instance.uid,
    };

const _$UigfNapPoolTypeEnumMap = {
  UigfNapPoolType.normal: '1',
  UigfNapPoolType.upC: '2',
  UigfNapPoolType.upW: '3',
  UigfNapPoolType.bond: '5',
};
